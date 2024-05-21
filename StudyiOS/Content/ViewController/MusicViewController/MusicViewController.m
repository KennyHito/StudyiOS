//
//  MusicViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/8.
//

#import "MusicViewController.h"

@interface MusicViewController ()
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation MusicViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bgView setHidden:YES];
}

/// 播放音乐
- (IBAction)boFang:(UIButton *)sender {
    [self.player play];
}

/// 暂停音乐
- (IBAction)zanTing:(UIButton *)sender {
    [self.player pause];
}

- (AVPlayer *)player{
    if(!_player){
        //获取资源
        NSString * path = [[NSBundle mainBundle]pathForResource:@"你还要我怎样" ofType:@"mp3"];
        AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:[NSURL fileURLWithPath:path]];
        //创建player
        _player = [[AVPlayer alloc]initWithPlayerItem:item];
    }
    return _player;
}

@end
