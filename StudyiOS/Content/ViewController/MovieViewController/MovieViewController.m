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

@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
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
    
    if(self.playerItem){
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
}

- (void)pageActivityStart{
    [self.player play];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
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
    
    // 添加加载指示器
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingIndicator.center = self.view.center;
    [self.loadingIndicator startAnimating];
    [self.view addSubview:self.loadingIndicator];
    
    // 添加错误提示标签
    self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    self.errorLabel.center = self.view.center;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.textColor = [UIColor redColor];
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.hidden = YES;
    [self.view addSubview:self.errorLabel];
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
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    self.playerItemObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        // 当视频播放结束时，将播放位置重置到开始处
        [self.player seekToTime:kCMTimeZero];
        // 重新开始播放
        [self.player play];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (playerItem.status) {
            case AVPlayerStatusReadyToPlay:
                [_loadingIndicator stopAnimating];
                _errorLabel.hidden = YES;
                break;
                
            case AVPlayerStatusFailed:
                [_loadingIndicator stopAnimating];
                [self showError:[NSString stringWithFormat:@"播放失败: %@", playerItem.error.localizedDescription] withDone:NO];
                break;
                
            case AVPlayerStatusUnknown:
                [self showError:@"视频状态未知" withDone:NO];
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
        NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval loadedDuration = startSeconds + durationSeconds;
        
        // 总时长
        NSTimeInterval totalDuration = CMTimeGetSeconds(playerItem.duration);
        
        NSLog(@"缓冲进度: %.2f%%", (loadedDuration / totalDuration) * 100);
        // 显示缓冲进度 (这里可以添加进度条UI)
        NSString *des = KStringWithFormat(@"缓冲进度: %.2f%%", (loadedDuration / totalDuration) * 100);
        BOOL isDone = (loadedDuration / totalDuration) * 100 >= 100;
        if (isDone) {
            des = @"缓存完成";
        }
        [self showError:des withDone:isDone];
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        if (playerItem.playbackBufferEmpty) {
            [_loadingIndicator startAnimating];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if (playerItem.playbackLikelyToKeepUp) {
            [_loadingIndicator stopAnimating];
        }
    }
}

- (void)showError:(NSString *)errorMessage withDone:(BOOL)isDone{
    self.errorLabel.text = errorMessage;
    self.errorLabel.hidden = NO;
    if (isDone) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.errorLabel.hidden = YES;
        });
    }
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
        //通过随机来播放本地视频还是网络视频
        int x = arc4random()%2;
        //网络视频url
        NSURL *movieURL = [NSURL URLWithString:MP4_URL];
        if (x == 1) {
            //选择本地的视频
            movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"qidong" ofType:@"mp4"]];
        }
        _playerItem = [AVPlayerItem playerItemWithURL:movieURL];
    }
    return _playerItem;
}

@end
