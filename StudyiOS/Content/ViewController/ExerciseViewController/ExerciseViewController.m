//
//  ViewController.m
//  StudyiOS
//
//  Created by Apple on 2022/10/31.
//

#import "ExerciseViewController.h"
#import "TimerViewController.h"
#import <dlfcn.h>
#import <sys/syscall.h>
#import <WebKit/WebKit.h>
#import <HaHaHa/HaInject.h>

#define Start_X     10.0f// 第一个按钮的X坐标
#define Start_Y     50.0f// 第一个按钮的Y坐标
#define Width_Space     5.0f// 2个按钮之间的横间距
#define Height_Space    20.0f// 竖间距
#define Button_Height   122.0f// 高
#define Button_Width    75.0f// 宽
#define btnHeight  50

@interface ExerciseViewController (){
    NSArray*arr;
    BOOL isOk;
    NSInteger index;
    int tem;
    BOOL isChangeLogo;//是否切换过logo
    int xxxxx;
}
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *animationImageView;
@property (nonatomic, strong)NSLock *lock;
@property (nonatomic, assign)int count;
@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong)NSArray *dataArr1;
@property (nonatomic, strong)NSMutableArray *dataArr2;
@property (nonatomic, strong)UIButton *lastBtn;
@end

@implementation ExerciseViewController
/*
 @dynamic 告诉编译器：属性的 setter 与 getter 方法由用户自己实现，不自动生成。（当然对于 readonly 的属性只需提供 getter 即可）。假如一个属性被声明为 @dynamic var，然后你没有提供 @setter方法和 @getter 方法，编译的时候没问题，但是当程序运行到 instance.var = someVar，由于缺 setter 方法会导致程序崩溃；或者当运行到 someVar = var 时，由于缺 getter 方法同样会导致崩溃。编译时没问题，运行时才执行相应的方法，这就是所谓的动态绑定。
 */
@dynamic money;
- (int)money{
    return xxxxx;
}
- (void)setMoney:(int)money{
    xxxxx = money;
}

- (void)dealloc{
    [self.webView.configuration.userContentController removeAllUserScripts];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //view已经布局其Subviews，这里可以放置调整完成之后需要做的工作。
}

- (void)viewDidLoad {
    [super viewDidLoad];
    KLog(@"金额为:-----> %d,%d",self.money,xxxxx);
    [[HaInject shareInstance] requestApi];
    [self initData];
    [self demo1];
    [self demo2];
    [self demo3];
    [self demo4];
    [self demo6];
    [self demo7];
    [self demo8];
    [self demo9];
    [self demo10];
    [self demo11];
    [self demo12];
    [self demo13];
    [self demo18];
    [self demo19];
    [self demo20];
    [self demo21];
    [self demo22];
    [self demo23];
}

- (void)initData{
    self.count = 10;
    self.lock = [[NSLock alloc] init];
    [self addObserver:self forKeyPath:@"isOk" options:0 context:nil];
    self.dataArr1 = @[@12,@54];
    self.dataArr2 = [NSMutableArray arrayWithArray:@[@"zhangsan",@"lisi",@"wangwu"]];
    //禁止被LLDB调试!也就是说这样连接Xcode运行app就会闪退
    //🌰方法一:
    //    ptrace(PT_DENY_ATTACH, 0, 0, 0);
    /**
     ⚠️ 如果直接直接使用上面这种方式不安全,为啥不安全呢?
     因为可以通过fishhook的方式进行禁掉,可参考inject这个类的方法。
     故需要间接使用! 具体怎么用呢,看下面代码👇🏻。
     先总结: 方法一和方法二其实根本都是通过ptrace的方式实现。
     */
    //🌰方式二:
    //    // 首先,需要拿到真实的路径,返回指针地址
    //    void *handle = dlopen("/usr/lib/system/libsystem_kernel.dylib", RTLD_LAZY);
    //    // 声明一个局部的指针地址
    //    int (*aPtrace)(int _request, pid_t _pid, caddr_t _addr, int _data);
    //    // 指针地址存储真实路径ptrace
    //    aPtrace = dlsym(handle, "ptrace");
    //    // 然后在设置禁止LLDB
    //    aPtrace(PT_DENY_ATTACH,0,0,0);
    
    
    //🌰方法三:
    //    syscall(26,31,0,0,0);
    
    //🌰方法四: 寄存器里面的值 通过svc指令(汇编指令) 触发cpu的中断
    //volatile: 告诉编译器不要优化此段汇编代码
    //    asm volatile(
    //                 "mov x0,#26\n"
    //                 "mov x1,#31\n"
    //                 "mov x2,#0\n"
    //                 "mov x3,#0\n"
    //                 "mov x16,#0\n"
    //                 "svc #0x80\n"
    //                 );
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(KTopHeight);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
}

// 所有的 kvo 监听到事件，都会调用此方法
/*
 1. 观察的属性
 2. 观察的对象
 3. change 属性变化字典（新／旧）
 4. 上下文，与监听的时候传递的一致
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
}

#pragma mark -- demo1
- (void)demo1{
    @synchronized (self) {
        [self.contentView addSubview:self.animationImageView];
        [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(31);
        }];
        [self.animationImageView startAnimating];
    };
}

- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],nil];
        _animationImageView.image = [UIImage imageNamed:@"1.png"];
        //imageView的动画图片是数组images
        _animationImageView.animationImages = images;
        //按照原始比例缩放图片，保持纵横比
        _animationImageView.contentMode = UIViewContentModeScaleAspectFit;
        //设置动画时长(以1秒3帧的规格)
        _animationImageView.animationDuration = 1;//可以理解1秒钟会将3张图全部显示一遍
        //动画的重复次数，想让它无限循环就赋成0
        _animationImageView.animationRepeatCount = 0;
        
    }
    return _animationImageView;
}

#pragma mark -- demo2
- (void)demo2{
    self.name = @"李四";
    KLog(@"我的名字叫:%@",self.name);
    arr = @[@"无知",@"风云变幻",@"施耐庵",@"唉",@"西门吹雪",@"呵呵哒",@"快看看",@"窿窿啦啦",@"一杆禽兽狙",@"合欢花",@"暴走大事件",@"非诚勿扰",@"呵呵呵",@"无知",@"风云变幻",@"施耐庵",@"唉",@"西门吹雪",@"呵呵哒",@"快看看",@"窿窿啦啦",@"一杆禽兽狙",@"合欢花",@"暴走大事件",@"非诚勿扰",@"呵呵呵"];
    
    self.scrollView = [[UIScrollView alloc] init];//WithFrame:CGRectMake(0, 35, KScreenW, 30)
    self.scrollView.backgroundColor = UIColorFromRGB(0x87CEFA);
    //设置显示内容的大小，这里表示可以下滑十倍原高度
    //设置当滚动到边缘继续滚时是否像橡皮经一样弹回
    self.scrollView.bounces = YES;
    //设置滚动条指示器的类型，默认是白边界上的黑色滚动条
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;//还有UIScrollViewIndicatorStyleBlack、UIScrollViewIndicatorStyleWhite
    //设置是否只允许横向或纵向（YES）滚动，默认允许双向
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    //设置是否采用分页的方式
    //    self.scrollView.pagingEnabled = YES;
    //设置是否允许滚动
    //        self.scrollView.scrollEnabled = NO;
    //设置是否可以缩放
    // self.scrollView.maximumZoomScale = 2.0;//最多放大到两倍
    // self.scrollView.minimumZoomScale = 0.5;//最多缩小到0.5倍
    //设置是否允许缩放超出倍数限制，超出后弹回
    // self.scrollView.bouncesZoom = YES;
    //设置委托
    // self.scrollView.delegate = self;
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.animationImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    NSInteger x = 5;
    for(NSInteger i=0; i<arr.count;i++){
        NSString*str = [arr objectAtIndex:i];
        CGFloat www = [str sizeWithAttributes:@{NSFontAttributeName:DDFont_PF_R(14)}].width + 16;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag= i ;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = DDFont_PF_R(14);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        btn.backgroundColor = UIColorFromRGB(0xDC143C);
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.scrollView.mas_centerY);
            make.left.mas_equalTo(self.scrollView.mas_left).offset(x);
            make.width.mas_equalTo(www);
            make.top.mas_equalTo(self.scrollView.mas_top).offset(5);
            make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-5);
            if(i==arr.count-1){
                make.right.mas_equalTo(self.scrollView.mas_right).offset(-5);
            }
        }];
        x = x + www +10;//10为两个标签之间的宽度间隔
    }
    self.scrollView.contentSize = CGSizeMake(x, 30);
}

- (void)click:(UIButton*)button{
    [self willChangeValueForKey:@"isOk"];
    // 只有自己去定义时才需要如此设置
    isOk = isOk?NO:YES;
    [self didChangeValueForKey:@"isOk"];
    
    KLog(@"%ld====%@",button.tag,arr[button.tag]);
    [DDToast showToast:arr[button.tag]];
}

#pragma mark -- demo3
- (void)demo3{
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@12,@34,@11,@90,@87,@66]];
    KLog(@"排序前--->%@",dataArr);
    //选择排序法
    for (int i = 0; i < dataArr.count - 1; i++) {
        for (int j = i+1; j < dataArr.count; j++) {
            if ([dataArr[i] intValue] > [dataArr[j] intValue]) {
                int temp = [dataArr[i] intValue];
                [dataArr replaceObjectAtIndex:i withObject:dataArr[j]];
                [dataArr replaceObjectAtIndex:j withObject:@(temp)];
            }
        }
    }
    KLog(@"选择排序法后--->%@",dataArr);
    
    dataArr = [NSMutableArray arrayWithArray:@[@22,@44,@11,@0,@7,@66]];
    //冒泡排序法
    for (int i = 0; i < dataArr.count - 1; i++) {
        for (int j = 0; j < dataArr.count - 1 - i; j++) {
            if ([dataArr[j] intValue] > [dataArr[j+1] intValue]) {
                int temp = [dataArr[j] intValue];
                [dataArr replaceObjectAtIndex:j withObject:dataArr[j+1]];
                [dataArr replaceObjectAtIndex:j+1 withObject:@(temp)];
            }
        }
    }
    KLog(@"冒泡排序法后--->%@",dataArr);
}

#pragma mark -- demo4
- (void)demo4{
    NSString *strrr = @"abcdefg";
    strrr = [strrr encodeBase64String];
    KLog(@"NSString --- Base64加密后的字符串：%@",strrr);
    strrr = [strrr decodeBase64String];
    KLog(@"NSString --- Base64解密后的字符串：%@",strrr);
}

#pragma mark -- demo6
- (void)demo6{
    NSMutableString *tttt = [[NSMutableString alloc] initWithString:@"张三"];
    NSMutableString *pppp = [tttt mutableCopy];
    KLog(@"%@-%@",tttt,pppp);
    [pppp appendString:@"李四"];
    KLog(@"%@-%@",tttt,pppp);
}

#pragma mark -- demo7
- (void)demo7{
    //折半查找
    NSArray *arr = @[@1,@10,@20,@25,@26,@27,@28];
    NSInteger key = 27;
    index = arr.count/2;
    tem = 0;
    [self array:arr key:key];
    KLog(@"key的索引=%ld, 循环次数=%d",(long)index,tem);
}

- (void)array:(NSArray *)arr key:(NSInteger)key {
    NSInteger center = [arr[index] integerValue];
    if ((index == 0 || index == arr.count-1) && center != key) {
        index = -1;//index为-1表示不存在
        return;
    }
    tem += 1;
    if (center == key) {
        return;
    }else{
        index = center > key ? index/2 : (index+(arr.count-index)/2);
        [self array:arr key:key];
    }
}

#pragma mark -- demo8
- (void)demo8{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"跳转page" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = DDFont_PF_M(22);
    btn.layer.cornerRadius = btnHeight/2.0;
    btn.layer.masksToBounds = YES;
    btn.tag = 1000;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(btnHeight);
    }];
    
    UIButton *changeLogoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeLogoBtn.backgroundColor = [UIColor redColor];
    changeLogoBtn.tag = 1001;
    [changeLogoBtn setTitle:@"Toast＋延迟5s" forState:UIControlStateNormal];
    [changeLogoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeLogoBtn.titleLabel.font = DDFont_PF_M(22);
    changeLogoBtn.layer.cornerRadius = btnHeight/2.0;
    changeLogoBtn.layer.masksToBounds = YES;
    [changeLogoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:changeLogoBtn];
    [changeLogoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(btnHeight);
    }];
    
    UIButton *autoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoBtn.backgroundColor = [UIColor redColor];
    autoBtn.tag = 1002;
    [autoBtn setTitle:@"Toast" forState:UIControlStateNormal];
    [autoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    autoBtn.titleLabel.font = DDFont_PF_M(22);
    autoBtn.layer.cornerRadius = btnHeight/2.0;
    autoBtn.layer.masksToBounds = YES;
    [autoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //⚠️sendActionsForControlEvents实现代码自动触发UIControlEventTouchUpInside事件。
    //[autoBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:autoBtn];
    [autoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(changeLogoBtn.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(btnHeight);
    }];
    self.lastBtn = autoBtn;
}

- (void)btnClick:(UIButton *)btn{
    if(btn.tag == 1000){
        TimerViewController *vc = [[TimerViewController alloc]init];
        vc.name = @"王五";
        [self.navigationController pushViewController:vc animated:YES];
    }else if(btn.tag == 1001){
        [DDToast showToast:ToastTypeSuccess text:@"成功" closeAfterDelay:5];
    }else if(btn.tag == 1002){
        [DDToast showToast:@"我是Toast"];
    }
}

#pragma mark -- demo9
- (void)demo9{
    KLog(@"两个大数相加算法:%@",[self addTwoNumberWithOneNumStr:@"123456789" anotherNumStr:@"987654321"]);
    KLog(@"两个大数相加算法:%@",[self addTwoNumberWithOneNumStr:@"987678924" anotherNumStr:@"111111111"]);
}

//两个大数相加算法
-(NSString *)addTwoNumberWithOneNumStr:(NSString *)one anotherNumStr:(NSString *)another
{
    int i = 0;
    int j = 0;
    int maxLength = 0;
    int sum = 0;
    int overflow = 0;
    int carryBit = 0;
    NSString *temp1 = @"";
    NSString *temp2 = @"";
    NSString *sums = @"";
    NSString *tempSum = @"";
    int length1 = (int)one.length;
    int length2 = (int)another.length;
    //1.反转字符串
    for (i = length1 - 1; i >= 0 ; i--) {
        NSRange range = NSMakeRange(i, 1);
        temp1 = [temp1 stringByAppendingString:[one substringWithRange:range]];
        KLog(@"%@",temp1);
    }
    for (j = length2 - 1; j >= 0; j--) {
        NSRange range = NSMakeRange(j, 1);
        temp2 = [temp2 stringByAppendingString:[another substringWithRange:range]];
        KLog(@"%@",temp2);
    }
    
    //2.补全缺少位数为0
    maxLength = length1 > length2 ? length1 : length2;
    if (maxLength == length1) {
        for (i = length2; i < length1; i++) {
            temp2 = [temp2 stringByAppendingString:@"0"];
            KLog(@"i = %d --%@",i,temp2);
        }
    }else{
        for (j = length1; j < length2; j++) {
            temp1 = [temp1 stringByAppendingString:@"0"];
            KLog(@"j = %d --%@",j,temp1);
        }
    }
    //3.取数做加法
    for (i = 0; i < maxLength; i++) {
        NSRange range = NSMakeRange(i, 1);
        int a = [temp1 substringWithRange:range].intValue;
        int b = [temp2 substringWithRange:range].intValue;
        sum = a + b + carryBit;
        if (sum > 9) {
            if (i == maxLength -1) {
                overflow = 1;
            }
            carryBit = 1;
            sum -= 10;
        }else{
            carryBit = 0;
        }
        tempSum = [tempSum stringByAppendingString:[NSString stringWithFormat:@"%d",sum]];
    }
    if (overflow == 1) {
        tempSum = [tempSum stringByAppendingString:@"1"];
    }
    int sumlength = (int)tempSum.length;
    for (i = sumlength - 1; i >= 0 ; i--) {
        NSRange range = NSMakeRange(i, 1);
        sums = [sums stringByAppendingString:[tempSum substringWithRange:range]];
    }
    KLog(@"sums = %@",sums);
    return sums;
}

#pragma mark -- demo10
- (void)demo10{
    TTStudySingle *singleT = [TTStudySingle shareInstance];
    TTStudySingle *singleT1 = [TTStudySingle alloc];
    TTStudySingle *singleT2 = [TTStudySingle new];
    TTStudySingle *singleT3 = [singleT1 copy];
    TTStudySingle *singleT4 = [singleT2 mutableCopy];
    KLog(@"demo10: %@-%@-%@-%@-%@",singleT,singleT1,singleT2,singleT3,singleT4);
}

#pragma mark -- demo11
- (void)demo11{
    //1，1，2，3，5，8，13，21，34，55，89...
    int n = 4;
    KLog(@"斐波那契数列第%d位数是%d",n,[self feibo:n]);
    
    NSArray *arr = @[@"a",@"b",@"c"];
    KLog(@"%@",[arr safeObjectAtIndex:4]);
    
    NSArray *data = @[@[@2],@[@3,@4],@[@6,@5,@7],@[@4,@1,@8,@3]];
    NSMutableString *endString = [[NSMutableString alloc]initWithString:@"最小路径是:"];
    for(int i = 0 ; i< data.count; i++){
        NSArray *childArr = data[i];
        int small = [childArr[0] intValue];
        for(int j = 0 ; j <childArr.count ; j++){
            if( small > [childArr[j] intValue]){
                small = [childArr[j] intValue];
            }
        }
        [endString appendFormat:@"%d,",small];
    }
    KLog(@"%@",endString);
}

//斐波那契数列
- (int)feibo:(int)n{
    if (n<2) {
        return n<1 ? 0 : 1;
    }else{
        return [self feibo:n-1] + [self feibo:n-2];
    }
}

#pragma mark -- demo12
- (void)demo12{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@49,@38,@65,@97,@76,@13,@27,@49, nil];
    [self inserSort:array];
}

/**
 插入排序
 @param array 需要排序的Array
 */
- (void)inserSort:(NSMutableArray *)array{
    // 插入排序的原理：始终定义第一个元素为有序的，将元素逐个插入到有序排列之中，其特点是要不断的
    
    // 移动数据，空出一个适当的位置，把待插入的元素放到里面去。
    for (int i = 0; i < array.count; i++) {
        
        NSNumber *temp = array[i];
        // temp 为待排元素 i为其位置 j为已排元素最后一个元素的位置（即取下一个元素，在已经排好序的元素序列中从后向前扫描）
        
        int j = i-1;
        
        // 当j < 0 时， i 为第一个元素 该元素认为已经是排好序的 所以不进入while循环
        while (j >= 0 && [array[j] intValue] > [temp intValue]) {
            //如果已经排好序的序列中元素大于新元素，则将该元素往右移动一个位置
            //也可以用OC方法：[array replaceObjectAtIndex:j+1 withObject:array[j]];
            array[j+1] = array[j];
            j--;
        }
        // 跳出while循环时，j的元素小于或等于i的元素(待排元素)。插入新元素 a[j+1] = temp,即将空出来的位置插入待排序的值
        //也可以用OC方法：[array replaceObjectAtIndex:j+1 withObject:temp];
        array[j+1] = temp;
        KLog(@"插入排序数组变化===:%@",[self inputArrayStr:array]);
    }
    KLog(@"array===:%@",array);
}

// 将数组中的元素拼接成字符串 - 方便打印
- (NSString *)inputArrayStr:(NSArray *)array {
    NSMutableString *strM = [NSMutableString string];
    for (NSNumber *num in array) {
        [strM appendString:[NSString stringWithFormat:@"%@,",num]];
    }
    return strM.copy;
}


#pragma mark -- demo13
- (void)demo13{
    NSArray *aArr = @[@2,@4];//假设这是有序链表a
    NSArray *bArr = @[@7,@9,@17];//假设这是有序链表b
    NSMutableArray *spliceArr = [[NSMutableArray alloc]init];
    //先将两个链表任意方式组合成链表
    [spliceArr addObjectsFromArray:aArr];
    [spliceArr addObjectsFromArray:bArr];
    [self inserSortData:spliceArr];
}

// 这里我采用了插入排序法 或者可以使用快速排序法的形式
- (void)inserSortData:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        NSNumber *temp = array[i];
        int j = i-1;
        while (j >= 0 && [array[j] intValue] > [temp intValue]) {
            array[j+1] = array[j];
            j--;
        }
        [array replaceObjectAtIndex:j+1 withObject:temp];
    }
    KLog(@"合并成最终一个链表的数据:%@",array);
}

#pragma mark -- demo18
- (void)demo18{
    //如何不用中间变量，用两种方法交换A和B的值？
    int x = 10;
    int y = 8;
    KLog(@"x=%d,y=%d",x,y);
    //方法一:
    x = x^y;
    y = x^y;
    x = x^y;
    KLog(@"x=%d,y=%d",x,y);
    //方法二:
    x = x + y;
    y = x - y;
    x = x - y;
    KLog(@"x=%d,y=%d",x,y);
}

#pragma mark -- demo19
- (void)demo19{
    //算法题
    /**
     Z国的货币系统包含面值1元、4元、16元、64元共计4种硬币，以及面值1024元的纸币。现在小Y使用1024元的纸币购买了一件价值为N (0 < N \le 1024)N(0<N≤1024)的商品，请问最少他会收到多少硬币？
     输入：200
     输出：17
     说明：花200，需要找零824块，找12个64元硬币，3个16元硬币，2个4元硬币即可。
     */
    int n = 200;
    int remain = 1024 - n;
    int num_64 = remain/64;
    int num_16 = remain%64/16;
    int num_4 = remain%64%16/4;
    int num_1 = remain%64%16%4/1;
    KLog(@"64元%d张,16元%d张,4元%d张,1元%d张,共计:%d张",num_64,num_16,num_4,num_1,num_64+num_16+num_4+num_1);
    
    /**
     1. 三个同样的字母连在一起，一定是拼写错误，去掉一个的就好啦：比如 helllo -> hello
     2. 两对一样的字母（AABB型）连在一起，一定是拼写错误，去掉第二对的一个字母就好啦：
     比如 helloo -> hello
     3.上面的规则优先“从左到右”匹配，即如果是AABBCC，虽然AABB和BBCC都是错误拼写，应该优先考虑修
     复AABB，结果为AABCC
     */
    KLog(@"%@",[self judgeString:[NSMutableString stringWithString:@"hellooo"]]);
    KLog(@"%@",[self judgeString:[NSMutableString stringWithString:@"wooooooow"]]);
    KLog(@"%@",[self judgeString:[NSMutableString stringWithString:@"heelooooooooo"]]);
}

- (NSMutableString *)judgeString:(NSMutableString *)xc{
    //含义: 0无 1AAA型 2AABB型
    int flag = 0;
    //默认取第一个
    NSString *temp = [xc substringWithRange:NSMakeRange(0, 1)];;
    for(int i = 1; i < [xc length]; i++){
        NSString *substring = [xc substringWithRange:NSMakeRange(i, 1)];
        if ([substring isEqualToString:temp]) {
            if (flag == 1 || flag == 2) {
                //如果是AAA型
                //第一个参数是要删除的字符的索引，第二个是从此位开始要删除的位数
                [xc deleteCharactersInRange:NSMakeRange(i, 1)];
                [self judgeString:xc];
            }
            flag = 1;//假设是AAA型 可能包含AABB型
        }else{
            if (flag == 1) {
                flag = 2;
            }else{
                flag = 0;
            }
            temp = substring;
        }
    }
    return xc;
}

#pragma mark -- demo20
- (void)demo20{
    // md5加密示例
    NSString *str = @"abcdefghijklmnopqrstuvwxyz";
    KLog(@"str md532BitLower : %@",[str md532BitLower]);
    KLog(@"str md532BitUpper : %@",[str md532BitUpper]);
    KLog(@"str getMD5Data : %@",[str getMD5Data]);
    
    //加盐后
    NSString *salt = @"123";
    NSString *newStr = [str stringByAppendingString:salt];
    KLog(@"newStr getMD5Data : %@",[newStr getMD5Data]);
}

#pragma mark -- demo21
- (void)demo21{
    NSArray *arr = @[@"12"];
    KLog(@"%@",arr[20]);
    //    [DDToast showToast:@"哈哈哈哈"];
}

#pragma mark -- demo22
- (void)demo22{
    KLog(@"YYKeyChainData : %@",[YYKeyChainData getUUIDByKeyChain]);
}

#pragma mark -- demo23
- (void)demo23{
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.backgroundColor = [UIColor redColor];
    [testBtn setTitle:@"测试深拷贝&浅拷贝" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testBtn.titleLabel.font = DDFont_PF_M(22);
    testBtn.layer.cornerRadius = btnHeight/2.0;
    testBtn.layer.masksToBounds = YES;
    [testBtn addTarget:self action:@selector(testBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:testBtn];
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lastBtn.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.scrollView.mas_centerX);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(btnHeight);
    }];
}

- (void)testBtnClick:(UIButton *)btn{
    /********************************浅拷贝(copy&mutableCopy)*****************************/
    NSArray *a1 = self.dataArr1;
    NSArray *a2 = [self.dataArr1 copy];
    NSArray *a3 = [self.dataArr1 mutableCopy];
    KLog(@"操作前----> %@,%@,%@,%@",self.dataArr1,a1,a2,a3);

    self.dataArr1 = @[@123];
    KLog(@"操作后----> %@,%@,%@,%@",self.dataArr1,a1,a2,a3);
    
    /********************************深拷贝(copy&mutableCopy)*****************************/
    NSMutableArray *b1 = self.dataArr2;
    NSMutableArray *b2 = [self.dataArr2 copy];
    NSMutableArray *b3 = [self.dataArr2 mutableCopy];
    KLog(@"操作前====> %@\n%@\n%@",b1,b2,b3);

    [self.dataArr2 addObject:@"maliu"];
    KLog(@"操作后====> %@\n%@\n%@",b1,b2,b3);
}
@end
