//
//  VideoView.m
//  iOSReview
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 KennyHito. All rights reserved.
//

#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoView()
{
    CGFloat width;//当前高度
    CGFloat height;//当前宽度
    CGFloat startWidth;//最初宽度
    CGFloat startHeight;//最初高度
    AVPlayerLayer * _layer;
    CGFloat light;
    CGFloat voice;
}

@property (nonatomic,strong) UILabel * startLab;//播放时间
@property (nonatomic,strong) UILabel * totalLab;//总时间
@property (nonatomic,strong) UISlider * slider;//进度条
@property (nonatomic,strong) UIButton * bigBtn;//放大
@property (nonatomic,strong) UIButton * playBtn;//播放,暂停
@property (nonatomic,strong) AVPlayer * player;//AVPlayer
@property (nonatomic,assign) BOOL flag;//横屏,竖屏
@property (nonatomic,strong) MPMusicPlayerController * mpVC;// <iOS7
@property (nonatomic,strong) MPVolumeView * volumeView;
@property (nonatomic,strong) UISlider * volumeViewSlider;
@property (nonatomic,copy) NSString * url;//视频地址

@end

@implementation VideoView
 //距离下边距
static CGFloat bottomHeight = 25;

/* 构造函数 */
- (instancetype)initWithFrame:(CGRect)frame AndURL:(NSString *)videoURL{
    if (self = [super initWithFrame:frame]) {
        self.url = videoURL;
        self.backgroundColor = [UIColor grayColor];
        width = self.bounds.size.width;
        startWidth = width;
        height = self.bounds.size.height;
        startHeight = height;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseTifi) name:@"pause" object:nil];
    
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panClick:)];
    [self addGestureRecognizer:pan];
    
    _flag = YES;
    [self.player play];
    [self setSubViewsFrame];
    [self setVideoTime];
    
    //获得当前屏幕亮度
    light = [UIScreen mainScreen].brightness;
    //获得系统当前音量
   
    //iOS7.0以前
    //_mpVC = [MPMusicPlayerController applicationMusicPlayer];
    //voice = _mpVC.volume;
    
     self.volumeView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * 9.0 / 16.0);
    
}
- (void)pauseTifi{
    [self.player pause];
}

#pragma mark -- 增加音量
- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

- (void)panClick:(UIPanGestureRecognizer *)panGR{
    
    //locationInView : 获取view的具体位置点
    CGPoint translation = [panGR locationInView:self];
    NSLog(@"位置 : x = %f,y = %f",translation.x,translation.y);
    
    //translationInView : X,Y轴上移动的像素
    //CGPoint point = [panGR translationInView:self];
    //NSLog(@"像素 : x = %f,y = %f",point.x,point.y);
    
    //velocityInView : 用来区分上下移动,还是左右移动
    CGPoint velocity = [panGR velocityInView:self];
    NSLog(@"移动: %f = %f",velocity.x,velocity.y);
    NSLog(@"--------------------------------");
    
    if (velocity.x>-10 && velocity.x<10) {
        //只能允许上下移动
        
        if (translation.x < width/2) {
            //左侧
            NSLog(@"<---左侧");
            if (velocity.y < 0) {
                if (light < 1) {
                    //向上滑动亮度增加
                    light = light + 0.1;
                }else{
                    //当亮度为1时固定为1，禁止大于1
                    light = 1;
                }
            }else{
                if (light > 0) {
                    //向下滑动屏幕变暗，亮度下降
                    light = light - 0.1;
                }else{
                    //当亮度为0时固定为0，禁止为负值
                    light = 0;
                }
            }
            //设置屏幕亮度
            [UIScreen mainScreen].brightness = light;
            
        }else{
            //右侧
            NSLog(@"右侧--->");
            if (velocity.y < 0) {
                if (voice < 1) {
                    voice = voice + 0.1;
                }else{
                    voice = 1;
                }
            }else{
                if (voice > 0) {
                    voice = voice - 0.1;
                }else{
                    voice = 0;
                }
            }
            //iOS7以前
            //[[MPMusicPlayerController applicationMusicPlayer] setVolume:voice];
            
            [self.volumeViewSlider setValue:voice animated:NO];
        }
    }

}

/* 设置控件大小 */
- (void)setSubViewsFrame{
    width = self.bounds.size.width;
    height= self.bounds.size.height;
    self.playBtn.frame = CGRectMake(10, height-bottomHeight, 20, 20);
    self.startLab.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame)+10, height-bottomHeight, 40, 20);
    self.bigBtn.frame = CGRectMake(KScreenW-30, height-bottomHeight, 20, 20);
    self.totalLab.frame = CGRectMake(CGRectGetMinX(self.bigBtn.frame)-50, height-bottomHeight, 40, 20);
    self.slider.frame = CGRectMake(CGRectGetMaxX(self.startLab.frame)+5,height-bottomHeight,KScreenW-CGRectGetWidth(self.playBtn.frame)-CGRectGetWidth(self.bigBtn.frame)-CGRectGetWidth(self.bigBtn.frame)-CGRectGetWidth(self.startLab.frame)-70,20);
    _layer.frame = CGRectMake(0, 0, width, height);
}

#pragma mark -------------------- 拖动滚动条 -------------------------
- (void)sliderClick:(UISlider *)sender{
    NSLog(@"%f",sender.value);
    [self.player pause];
    //获得当前时间
    CMTime currentTime = CMTimeMake(_player.currentItem.duration.value * sender.value, _player.currentItem.duration.timescale);
    //跳转到curentTime的位置播放
    if (!currentTime.timescale) {
        NSLog(@"视频正在缓冲中...");
    }else{
        [self.player seekToTime:currentTime];
        [self.player play];
    }
}
/* 获取视频时间 */
- (void)setVideoTime{
    __weak typeof(self)weakSelf = self;
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //获取总时间
        float totalTime = weakSelf.player.currentItem.duration.value*1.0/weakSelf.player.currentItem.duration.timescale;
        
        //获取当前时间
        float currentTime = weakSelf.player.currentItem.currentTime.value*1.0/weakSelf.player.currentTime.timescale;
        
        //NSLog(@"%.2f %.2f %@ %@",totalTime,currentTime,[weakSelf sendTimeCGFloat:totalTime],[weakSelf sendTimeCGFloat:currentTime]);
        
        //当前播放时间
        weakSelf.startLab.text = [NSString stringWithFormat:@"%@",[weakSelf sendTimeCGFloat:currentTime]];
        //显示总时间
        weakSelf.totalLab.text = [NSString stringWithFormat:@"%@",[weakSelf sendTimeCGFloat:totalTime]];
        
        //用来显示拖动条的进度值
        weakSelf.slider.value = currentTime/totalTime;
    }];
}

#pragma mark --------------------------事件---------------------------
/* 横屏,竖屏 */
- (void)bigBtnClick{
    NSString * str;
    if (_flag) {
        //横屏
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
        _flag = false;
        self.frame = CGRectMake(0, 0, KScreenW, KScreenH);
        str = @"heng";
    }else{
        //竖屏
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        _flag = YES;
        self.frame = CGRectMake(0, 0, startWidth, startHeight);
        str = @"shu";
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tifi" object:self userInfo:@{@"fang":str}];
    
    [self setSubViewsFrame];
    
}

/* 外部更改横竖屏 */
- (void)HitoChangeHeng{
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    _flag = YES;
    self.frame = CGRectMake(0, 0, startWidth, startHeight);
    [self setSubViewsFrame];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tifi" object:self userInfo:@{@"fang":@"shu"}];
}

/* 播放,暂停 */
- (void)playBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.player pause];
    }else{
        [self.player play];
    }
}

/* 拖动条点击事件 */
- (void)tapGRClick:(UITapGestureRecognizer *)sender {
    //1.首先设置slider上的值
    CGPoint touchPoint = [sender locationInView:_slider];
    CGFloat value = (_slider.maximumValue - _slider.minimumValue) * (touchPoint.x / _slider.frame.size.width );
    [_slider setValue:value animated:YES];
    
    //2.根据value设置播放进度
    CMTime currentTime = CMTimeMake(_player.currentItem.duration.value * value, _player.currentItem.duration.timescale);
    //跳转到curentTime的位置播放
    if (!currentTime.timescale) {
        NSLog(@"视频正在缓冲中...");
    }else{
        [self.player seekToTime:currentTime];
        [self.player play];
    }
}


#pragma mark ------------------------设置时间--------------------------
- (NSString *)sendTimeCGFloat:(CGFloat)time{
    //转化时间的格式
    NSDate*d = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    if(time/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    }else{
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString * showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

#pragma mark -------------------------懒加载----------------------------
- (AVPlayer *)player{
    if (!_player) {
        AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
        _player = [[AVPlayer alloc]initWithPlayerItem:item];
        _layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _layer.frame = CGRectMake(0, 0, width, height);
        _layer.videoGravity = AVLayerVideoGravityResizeAspect;
        _layer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_layer];
    }
    return _player;
}

- (UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:0];
        _playBtn.frame = CGRectMake(10, height-bottomHeight, 20, 20);
        [_playBtn setImage:[UIImage imageNamed:@"videoPause"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"videoPlay"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
    }
    return _playBtn;
}

- (UILabel *)startLab{
    if (!_startLab) {
        _startLab = [[UILabel alloc]init];
        _startLab.frame = CGRectMake(CGRectGetMaxX(_playBtn.frame)+10, height-bottomHeight, 40, 20);
        _startLab.text = @"00:00";
        _startLab.textColor = [UIColor whiteColor];
        _startLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:_startLab];
    }
    return _startLab;
}
- (UIButton *)bigBtn{
    if (!_bigBtn) {
        _bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bigBtn.frame = CGRectMake(KScreenW-30, height-bottomHeight, 20, 20);
        [_bigBtn setImage:[UIImage imageNamed:@"fangda"] forState:UIControlStateNormal];
        [_bigBtn addTarget:self action:@selector(bigBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bigBtn];
    }
    return _bigBtn;
}
- (UILabel *)totalLab{
    if (!_totalLab) {
        _totalLab = [[UILabel alloc]init];
        _totalLab.frame = CGRectMake(CGRectGetMinX(self.bigBtn.frame)-50, height-bottomHeight, 40, 20);
        _totalLab.text = @"00:00";
        _totalLab.textColor = [UIColor whiteColor];
        _totalLab.font = [UIFont systemFontOfSize:11];
        [self addSubview:_totalLab];
    }
    return _totalLab;
}
- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        _slider.frame = CGRectMake(CGRectGetMaxX(self.startLab.frame)+5,height-bottomHeight,KScreenW-CGRectGetWidth(self.playBtn.frame)-CGRectGetWidth(self.bigBtn.frame)-CGRectGetWidth(self.bigBtn.frame)-CGRectGetWidth(self.startLab.frame)-70,20);
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        [_slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
        UIImage * imagea= [self OriginImage:[UIImage imageNamed:@"jindudian"] scaleToSize:CGSizeMake(15, 15)];
        [_slider setThumbImage:imagea forState:UIControlStateNormal];
        
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRClick:)];
        [_slider addGestureRecognizer:tapGR];
        [self addSubview:_slider];
    }
    return _slider;
}

/*
 对原来的图片的大小进行处理
 @param image 要处理的图片
 @param size  处理过图片的大小
 */
- (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}



@end
