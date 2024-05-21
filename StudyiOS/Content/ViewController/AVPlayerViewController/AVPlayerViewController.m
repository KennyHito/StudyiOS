//
//  AVPlayerViewController.m
//  iOSReview
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import "AVPlayerViewController.h"
#import "VideoView.h"

@interface AVPlayerViewController ()

@property (nonatomic,copy) NSString * flag;
@property (nonatomic,strong) VideoView * videoV;

@end

@implementation AVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tifi:) name:@"tifi" object:nil];
    
    _videoV = [[VideoView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 240) AndURL:MP4_URL];
    [self.bgView addSubview:_videoV];
    
    //重写返回按钮功能
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"videoback"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark ------------------返回按钮--------------------
- (void)back{
    if ([self.flag isEqualToString:@"heng"]) {
        [_videoV HitoChangeHeng];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pause" object:nil];
    }
}

- (void)tifi:(NSNotification *)cation{
    NSDictionary * dic = cation.userInfo;
    self.flag = dic[@"fang"];
}

@end
