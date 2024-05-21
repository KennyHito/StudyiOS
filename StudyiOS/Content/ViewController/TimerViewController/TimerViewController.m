//
//  firstViewController.m
//  iOSTest
//
//  Created by admin on 2022/3/10.
//

#import "TimerViewController.h"

@interface TimerViewController ()
{
    NSString *_testTitle;
}
@property (weak, nonatomic) IBOutlet UILabel *testLab;
@property (nonatomic,copy) NSString *des;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation TimerViewController

- (void)dealloc{
    KLog(@"我被释放了!");
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    /**⚠️如果这样初始化会出现循环引用的问题⚠️*/
    //    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    /** 👇🏻解决NSTimer循环引用的方法,如下👇🏻 */
    /** 🌰方法一:block回调通过弱引用的方式,但是该方法只有iOS10以上才可以使用 */
    //    WS(weakSelf);
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        [weakSelf timerEvent];
    //    }];
    //    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    /** 🌰方法二:通过NSObject中间量的形式,需要配合消息转发 */
    self.timer = [NSTimer timerWithTimeInterval:2 target:[TTMiddleObject callObjectTarget:self] selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    /** 🌰方法三:NSProxy 是一个抽象基类，它是为一些作为对象的替身或者并不存在的对象定义的API。
     一般的，发送给代理的消息被转发给一个真实的对象或者代理本身引起加载(或者将本身转换成)一个真实的对象。
     NSProxy的基类可以被用来透明的转发消息或者耗费巨大的对象的lazy初始化。*/
    //    self.timer = [NSTimer timerWithTimeInterval:2 target:[TTMiddleProxy callObjectTarget:self] selector:@selector(timerEvent) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerEvent{
    KLog(@"时钟被执行了");
}

- (void)initData{
    self.view.userInteractionEnabled = YES;
    [DDUIFunction addViewTapGesture:self.view delegate:self action:@selector(tapEvent:)];
    
    /*富文本的使用*/
    NSString *testString =
    @"一要坚持多边主义，加强国际合作。合力营造开放、包容、公平、公正、非歧视的数字经济发展环境，在数字产业化、产业数字化方面推进国际合作，释放数字经济推动全球增长的潜力。搞所谓“小院高墙”、限制或阻碍科技合作，损人不利己，不符合国际社会共同利益。二要坚持发展优先，弥合数字鸿沟。各国应该携手推动数字时代互联互通，采取有效措施提升全民数字技能和素养，尤其要帮助发展中国家和弱势群体融入数字化浪潮，努力消除数字鸿沟。中方已经发起建设数字丝绸之路倡议，并将数字经济作为全球发展倡议的重点合作领域，期待就此同各方开展合作。三要坚持创新驱动，助力疫后复苏。中方提出了《二十国集团数字创新合作行动计划》，旨在推动数字技术创新应用，实现创新成果普惠共享，欢迎各方积极参与。中方愿继续同二十国集团成员合作，携手构建普惠平衡、协调包容、合作共赢、共同繁荣的全球数字经济格局。";
    
    self.testLab.userInteractionEnabled = YES;
    self.testLab.numberOfLines = 0;
    self.testLab.font = DDFont_PF_R(20);
    self.testLab.lineBreakMode = NSLineBreakByClipping;
    [DDUIFunction addViewTapGesture:self.testLab delegate:self action:@selector(tapEvent:)];
    NSMutableAttributedString *attrMu = [[NSMutableAttributedString alloc] initWithString:testString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attrMu addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrMu length])];
    
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"sp_main_read_hot"];
    attachment.bounds = CGRectMake(0, -2, 28, 14);
    NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:attachment];
    [attrMu insertAttributedString:icon atIndex:0];
    
    self.testLab.attributedText = attrMu;
}

- (void)tapEvent:(UITapGestureRecognizer *)tap{
    if(tap.view == self.testLab){
        
    }else{
        kWeakify(self);
        if (self.MyBBLock) {
            KStrongify(self);
            self.MyBBLock(@"星期二");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
