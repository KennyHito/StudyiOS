//
//  SudokuViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/3.
//

#import "SudokuViewController.h"
#import "CLLockVC.h"

@interface SudokuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *replaceButton;

@end

@implementation SudokuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bgView setHidden:YES];
    KViewRadius(self.setButton, CGRectGetHeight(self.setButton.frame)/2.0);
    KViewRadius(self.clearButton, CGRectGetHeight(self.clearButton.frame)/2.0);
    KViewRadius(self.verifyButton, CGRectGetHeight(self.verifyButton.frame)/2.0);
    KViewRadius(self.replaceButton, CGRectGetHeight(self.replaceButton.frame)/2.0);
}

//设置密码
- (IBAction)setUpBtn:(UIButton *)sender {
    BOOL hasPwd = [CLLockVC hasPwd];
    if(hasPwd){
        [DDToast showToast:@"已经设置过密码了，你可以验证或者修改密码"];
    }else{
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [DDToast showToast:@"设置密码成功"];
            [lockVC dismiss:1.0f];
        }];
    }
}

//清空密码
- (IBAction)clearBtnClick:(UIButton *)sender {
    [CLLockVC clearPwd];
}

//验证密码
- (IBAction)checkBtn:(UIButton *)sender {
    BOOL hasPwd = [CLLockVC hasPwd];
    if(!hasPwd){
        [DDToast showToast:@"你还没有设置密码，请先设置密码"];
    }else {
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            [DDToast showToast:@"点击了忘记密码按钮"];
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [DDToast showToast:@"密码正确"];
            [lockVC dismiss:1.0f];
        }];
    }
}

//修改密码
- (IBAction)replaceBtn:(UIButton *)sender {
    BOOL hasPwd = [CLLockVC hasPwd];
    if(!hasPwd){
        [DDToast showToast:@"你还没有设置密码，请先设置密码"];
    }else {
        [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [DDToast showToast:@"修改密码成功"];
            [lockVC dismiss:.5f];
        }];
    }
}

@end
