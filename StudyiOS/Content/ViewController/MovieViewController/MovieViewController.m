//
//  MovieViewController.m
//  startMovie
//
//  Created by Apple on 2017/7/17.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import "MovieViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MovieViewController ()

@property (nonatomic, strong) AVPlayer * player;
@property (strong, nonatomic) AVPlayerLayer * layer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) id playerItemObserver;
@end

@implementation MovieViewController

- (void)dealloc{
    KLog(@"移除观察者 --- 停止播放");
    // 移除观察者
    if (self.playerItemObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.playerItemObserver];
    }
    // 停止播放
    if(self.player){
        [self.player pause];
        self.player = nil;
    }
}

- (void)pageActivityStart{
    [self.player play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.player play];//进来直接默认播放
    [self setUpUI];
    [self monitorPlaybackProgress];
}

- (void)setUpUI{
    UIButton *skipButton = [[UIButton alloc] init];
    skipButton.frame = CGRectMake(KScreenW - 80, KNavBarHeight, 60, 35);
    skipButton.layer.borderWidth = 1;
    skipButton.layer.cornerRadius = CGRectGetHeight(skipButton.frame)/2.0;
    skipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
    skipButton.alpha = 0;
    [skipButton addTarget:self action:@selector(skipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
    [UIView animateWithDuration:3.0 animations:^{
        skipButton.alpha = 1.0;
    }];
    
    //进入按钮
    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.frame = CGRectMake(24, KScreenH - KSafeAreaHeight - 48, KScreenW - 48, 48);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    enterMainButton.alpha = 0;
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterMainButton];
    [UIView animateWithDuration:3.0 animations:^{
        enterMainButton.alpha = 1.0;
    }];
}

#pragma mark -- 按钮点击
- (void)skipButtonClick:(UIButton *)btn{
    [self enterMainViewcontroller];
}

- (void)enterMainAction:(UIButton *)btn {
    //记录上,在本次版本内不在显示,清除缓存后可以再次显示
    [HsConfig writeUserDefaultWithKey:VersionCache WithValue:APPVERSION];
    [self enterMainViewcontroller];
}

/// 进入App
- (void)enterMainViewcontroller{
    MainTabBarViewController *tabBar = [[MainTabBarViewController alloc] init];
    self.view.window.rootViewController = tabBar;
}

#pragma mark -- 监听播放进度
- (void)monitorPlaybackProgress{
    self.playerItemObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        // 当视频播放结束时，将播放位置重置到开始处
        [self.player seekToTime:kCMTimeZero];
        // 重新开始播放
        [self.player play];
    }];
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        _layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _layer.frame = CGRectMake(0, 0, KScreenW, KScreenH);
        _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;//视频拉伸显示
        //        _layer.backgroundColor = [UIColor blackColor].CGColor;
        [self.view.layer addSublayer:_layer];
    }
    return _player;
}

- (AVPlayerItem *)playerItem{
    if(!_playerItem){
        //选择本地的视频
        NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"qidong" ofType:@"mp4"]];
        //网络视频
        //movieURL = [NSURL URLWithString:MP4_URL];
        _playerItem = [AVPlayerItem playerItemWithURL:movieURL];
    }
    return _playerItem;
}

@end
