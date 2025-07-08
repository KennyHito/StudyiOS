//
//  FlashlightViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "FlashlightViewController.h"

@interface FlashlightViewController ()

@end

@implementation FlashlightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kWeakify(self)
    [self.bgView createButtonTitle:@"打开/关闭闪光灯" andFont:20 andTitleColor:[UIColor whiteColor] andBackgroundColor:[UIColor redColor] andFrame:CGRectMake((KScreenW-200)/2, 10, 200, 50) actionBlock:^(UIButton * _Nonnull button) {
        KStrongify(self);
        [self commonMethod:button];
    }];
}

//按钮点击事件的实现
- (void)commonMethod:(UIButton *)sender{
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
