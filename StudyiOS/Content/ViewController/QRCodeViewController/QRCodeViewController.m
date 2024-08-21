//
//  QRCodeViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/21.
//

#import "QRCodeViewController.h"

#import <AVFoundation/AVFoundation.h>//需要添加AVFoundation系统库
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>//遵守相应代理

@property (strong,nonatomic) UIButton *btn;
@property (strong,nonatomic) AVCaptureDevice * device;//采集的设备
@property (strong,nonatomic) AVCaptureDeviceInput * input;//设备的输入
@property (strong,nonatomic) AVCaptureMetadataOutput * output;//输出
@property (strong,nonatomic) AVCaptureSession * session;//采集流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * preview;//窗口
@property (copy,nonatomic) NSString * stringValue;//得到解析到的结果
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor yellowColor];
    [btn setTitle:@"扫描二维码" forState:UIControlStateNormal];
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
        make.width.mas_equalTo(120);
    }];
}

//按钮点击事件的实现
- (void)btnClick:(UIButton *)btn{
    // Device 实例化设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input 设备输入
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output 设备的输出
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    // Preview 扫描窗口设置
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = CGRectMake(80,100,KScreenW-160,KScreenW-160);
    _preview.cornerRadius = 10;
    _preview.masksToBounds = YES;
    [self.bgView.layer insertSublayer:self.preview atIndex:0];
    
    // Start 开始扫描
    [_session startRunning];
    
}
//解析结果的代理方法
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        _stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];//停止扫描
    
    NSString *alertButtonTitle = @"复制";
    NSString *alertTitle = @"";
    if ([_stringValue hasPrefix:@"http://"] || [_stringValue hasPrefix:@"https://"]) {
        alertButtonTitle = @"跳转";
        alertTitle = @"是否在浏览器中打开此链接";
    }
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitle message:[NSString stringWithFormat:@"扫描结果是:%@",_stringValue] delegate:self cancelButtonTitle:nil otherButtonTitles:alertButtonTitle,@"取消", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        if (alertView.title.length > 0) {
            //打开浏览器
            [self openFuncCommd:_stringValue];
        }else{
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = _stringValue;
            if (pab == nil) {
                [DDToast showToast:@"复制失败"];
            } else {
                [DDToast showToast:@"已复制"];
            }
        }
        [_preview removeFromSuperlayer];
    }else{
        //重新扫描
        [_session startRunning];
    }
}

#pragma mark -- 跳转的方法
//通过命令打开功能
- (void)openFuncCommd:(NSString *)str{
    //NSString转NSURL
    NSURL * url = [NSURL URLWithString:str];
    //当前程序
    UIApplication * app = [UIApplication sharedApplication];
    //判断
    if ([app canOpenURL:url]) {
        
        [app openURL:url];
        
    }else{
        NSLog(@"没有此功能或者该功能不可用");
    }
}

@end
