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
    kWeakify(self)
    UIButton * btn = [self.bgView createButtonTitle:@"请求一下接口" andFont:20 andTitleColor:[UIColor whiteColor] andBackgroundColor:[UIColor redColor] andFrame:CGRectMake((KScreenW-200)/2, 10, 200, 50) actionBlock:^(UIButton * _Nonnull button) {
        KStrongify(self)
        [self RequestMethod];
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

- (void)RequestMethod{
    kWeakify(self);
    [HttpCommonRequest requestByGetWithUrl:Request_Api_1 param:nil success:^(id _Nonnull responseObject) {
        KStrongify(self);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"] intValue] == 200) {
            self.model = [RequestAPIModel mj_objectWithKeyValues:dic[@"data"]];
            NSLog(@"%@",self.model.content);
            self.desLab.text = KStringWithFormat(@"👇🏻接口请求的结果内容如下:👇🏻\n\nID:%@\ncontent:%@\n",self.model.ID,self.model.content);
        }else{
            [DDToast showToast:responseObject[@"msg"]];
        }
    } failure:^(NSError * _Nonnull error) {
        [DDToast showToast:error.localizedDescription];
    }];
}

@end
