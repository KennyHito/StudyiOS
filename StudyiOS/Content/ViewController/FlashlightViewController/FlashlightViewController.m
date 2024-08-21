//
//  FlashlightViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "FlashlightViewController.h"

@interface FlashlightViewController ()
@property (strong,nonatomic) UIButton *btn;
@end

@implementation FlashlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitle:@"打开/关闭闪光灯" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.bgView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    self.btn = btn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.top.mas_equalTo(self.bgView.mas_top).offset(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(180);
    }];
}

//按钮点击事件的实现
- (void)btnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        
        //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        
    }else{
        
        //关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            BOOL locked = [device lockForConfiguration:nil];
            if (locked) {
                [device setTorchMode: AVCaptureTorchModeOff];
                [device unlockForConfiguration];
            }
        }
    }
}

@end
