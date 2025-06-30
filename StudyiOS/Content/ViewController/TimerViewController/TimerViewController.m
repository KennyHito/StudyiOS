//
//  firstViewController.m
//  iOSTest
//
//  Created by admin on 2022/3/10.
//

#import "TimerViewController.h"

@interface TimerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLab;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation TimerViewController

- (void)dealloc{
    KLog(@"我被释放了!");
    [self.timer invalidate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.bgView setHidden:YES];
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
    NSString *msg_str = @"中国人民是具有伟大奋斗精神的人民。在几千年历史长河中，中国人民始终革故鼎新、自强不息，开发和建设了祖国辽阔秀丽的大好河山，开拓了波涛万顷的辽阔海疆，开垦了物产丰富的广袤粮田，治理了桀骜不驯的千百条大江大河，战胜了数不清的自然灾害，建设了星罗棋布的城镇乡村，发展了门类齐全的产业，形成了多姿多彩的生活。中国人民自古就明白，世界上没有坐享其成的好事，要幸福就要奋斗。今天，中国人民拥有的一切，凝聚着中国人的聪明才智，浸透着中国人的辛勤汗水，蕴涵着中国人的巨大牺牲。我相信，只要13亿多中国人民始终发扬这种伟大奋斗精神，我们就一定能够达到创造人民更加美好生活的宏伟目标！中国人民是具有伟大团结精神的人民。在几千年历史长河中，中国人民始终团结一心、同舟共济，建立了统一的多民族国家，发展了56个民族多元一体、交织交融的融洽民族关系，形成了守望相助的中华民族大家庭。特别是近代以后，在外来侵略寇急祸重的严峻形势下，我国各族人民手挽着手、肩并着肩，英勇奋斗，浴血奋战，打败了一切穷凶极恶的侵略者，捍卫了民族独立和自由，共同书写了中华民族保卫祖国、抵御外侮的壮丽史诗。今天，中国取得的令世人瞩目的发展成就，更是全国各族人民同心同德、同心同向努力的结果。中国人民从亲身经历中深刻认识到，团结就是力量，团结才能前进，一个四分五裂的国家不可能发展进步。我相信，只要13亿多中国人民始终发扬这种伟大团结精神，我们就一定能够形成勇往直前、无坚不摧的强大力量！中国共产党和中国人民是在斗争中成长和壮大起来的，斗争精神贯穿于中国革命、建设、改革各个时期。我国正处于实现中华民族伟大复兴关键时期，改革发展正处在攻坚克难的重要阶段，在前进道路上，我们面临的重大斗争不会少。我们必须以越是艰险越向前的精神奋勇搏击、迎难而上。凡是危害中国共产党领导和我国社会主义制度的各种风险挑战，凡是危害我国主权、安全、发展利益的各种风险挑战，凡是危害我国核心利益和重大原则的各种风险挑战，凡是危害我国人民根本利益的各种风险挑战，凡是危害我国实现“两个一百年”奋斗目标、实现中华民族伟大复兴的各种风险挑战，只要来了，我们就必须进行坚决斗争，毫不动摇，毫不退缩，直至取得胜利。历史必将证明，中华民族走向伟大复兴的历史脚步是不可阻挡的。任何人任何势力企图通过霸凌手段把他们的意志强加给中国、改变中国的前进方向、阻挠中国人民创造自己美好生活的努力，中国人民都绝不答应！";
    
    NSMutableAttributedString *attrMu = [[NSMutableAttributedString alloc] initWithString:msg_str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attrMu addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrMu length])];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"sp_main_read_hot"];
    attachment.bounds = CGRectMake(0, -2, 28, 14);
    NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:attachment];
    [attrMu insertAttributedString:icon atIndex:0];
    
    self.testLab.attributedText = attrMu;
    self.testLab.numberOfLines = 0;
    self.testLab.font = DDFont_PF_R(20);
    self.testLab.lineBreakMode = NSLineBreakByClipping;
    self.testLab.userInteractionEnabled = YES;
    [DDUIFunction addViewTapGesture:self.testLab delegate:self action:@selector(tapEvent:)];
}

- (void)tapEvent:(UITapGestureRecognizer *)tap{
    if(tap.view == self.testLab){
        kWeakify(self);
        if (self.MyBBLock) {
            KStrongify(self);
            self.MyBBLock(@"星期二");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
