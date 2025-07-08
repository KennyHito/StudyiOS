//
//  SavePicViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "SavePicViewController.h"

@interface SavePicViewController ()
@property (nonatomic,strong) UIImageView * imageV;
@end

@implementation SavePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     保存图片有两种方式:
     1>.按钮方式;
     2>.长按图片方式;
     */

    //方式一 : 创建按钮
    kWeakify(self)
    UIButton * btn = [self.bgView createButtonTitle:@"保存相册" andFont:20 andTitleColor:[UIColor whiteColor] andBackgroundColor:[UIColor redColor] andFrame:CGRectMake((KScreenW-200)/2, 10, 200, 50) actionBlock:^(UIButton * _Nonnull button) {
        KStrongify(self)
        [self savePicture:self.imageV.image];
    }];
    
    //显示图片
    self.imageV = [[UIImageView alloc] init];
    //[注意🐷] : "mainAD" 这里是图片名的名字,用户更改成相应的图片名
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:@"https://img1.baidu.com/it/u=3810918353,2913745731&fm=253&fmt=auto&app=138&f=JPEG?w=1200&h=800"] placeholderImage:[UIImage imageNamed:@"mainAD"]];
    [self.bgView addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(20);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
        make.top.mas_equalTo(btn.mas_bottom).offset(20);
        make.height.mas_equalTo(200);
    }];
    
    //方式二 : 给图片添加长按手势
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
    //设置长按时间,默认0.5秒
    longPress.minimumPressDuration = 1.0;
    //使用手势必须开启交互性
    self.imageV.userInteractionEnabled = YES;
    [self.imageV addGestureRecognizer:longPress];
    
    UILabel * lab = [[UILabel alloc] init];
    lab.text = @"⚠️: 该模块的功能是将图片保存到系统的相册中,保存的方式有两种,一是通过点击保存按钮;二是通过长按图片即可保存!";
    lab.font = [UIFont systemFontOfSize:17];
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.numberOfLines = 3;
    [self.bgView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(20);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-20);
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(20);
        make.height.mas_equalTo(80);
    }];
}

//长按手势实现图片保存
- (void)longPressClick:(UIGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan ) {
        [self savePicture:self.imageV.image];
    }
}

//按钮点击事件的实现
- (void)btnClick:(UIButton *)btn{
   
}

/* 保存图片的方法 */
- (void)savePicture:(UIImage *)image{
   UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (!error) {
        [DDToast showToast:@"图片保存成功!"];
    }else{
        NSLog(@"%@",error.localizedDescription);
    }
}

@end
