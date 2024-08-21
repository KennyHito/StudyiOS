//
//  RequestAPIViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "RequestAPIViewController.h"
#import "RequestAPIModel.h"

@interface RequestAPIViewController ()

@property (nonatomic,strong) RequestAPIModel *model;
@property (nonatomic,strong) UILabel *desLab;

@end

@implementation RequestAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitle:@"请求一下" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.bgView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_top).offset(15);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    
    UILabel * lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:17];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 0;
    self.desLab = lab;
    [self.bgView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(20);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
        make.top.mas_equalTo(btn.mas_bottom).offset(20);
    }];
}

//按钮点击事件的实现
- (void)btnClick:(UIButton *)btn{
    kWeakify(self);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript", @"text/json", nil];
    [manager GET:@"https://api.xygeng.cn/one" parameters:nil headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        KStrongify(self);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"] intValue] == 200) {
            self.model = [RequestAPIModel mj_objectWithKeyValues:dic[@"data"]];
            NSLog(@"%@",self.model.content);
            self.desLab.text = KStringWithFormat(@"👇🏻接口请求的结果内容如下:👇🏻\n\n%@",self.model.content);
        }else{
            [DDToast showToast:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [DDToast showToast:error.localizedDescription];
    }];
}

@end
