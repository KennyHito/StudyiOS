//
//  AboutViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/20.
//

#import "AboutViewController.h"
#import <Photos/Photos.h>
#import <objc/runtime.h>
#import <Test01/TestInject.h>

#define Tab_Flag                @"Tab_Flag"
#define Tab_Title               @"Tab_Title"
#define Tab_Sub_Title           @"Tab_Sub_Title"
#define CellID                  @"cellid"

//接口返回数据是否json日志打印
#define kHsPrintLogJson         @"isPrintLogJson"

@interface AboutViewController ()
<
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UIImageView * topImageView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) PrivacyCheckGatherTool *privacyTool;
@property (nonatomic,assign) NSInteger networkType;//0无网络,1蜂窝,2WiFi
@property (nonatomic,assign) NSInteger row;//支持点击跳转的所在行数
@property (nonatomic,strong) UIImage *iconImage;

@end

@implementation AboutViewController
//app进入前台实现的通知
- (void)pageActivityStart{
    [super pageActivityStart];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /// 组件工程
    [TestInject requestApiBlock:^(id  _Nonnull obj) {
        if([[HsConfig readUserDefaultWithKey:kHsPrintLogJson] isEqualToString:@"1"]){
            if([obj isKindOfClass:[NSDictionary class]]){
                KLog(@"%@",[(NSDictionary *)obj jsonString]);
            }else{
                KLog(@"%@",obj);
            }
        }else{
            KLog(@"%@",obj);
        }
    }];
}

#pragma mark -- 将导航栏归还原样
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //进入页面导航栏设置为隐藏
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];

    [self initData];
    [self setUI];
    [self createTopImageView];
    [self requestNetwork];
}

- (void)initData{
    [self.dataArr removeAllObjects];
    NSInteger locationAuto = [PrivacyCheckGatherTool locationAuthorizationStatus];
    NSInteger pushAuth = [PrivacyCheckGatherTool pushAuthorizationStatus];
    NSInteger cameraAuth = [PrivacyCheckGatherTool cameraAuthorizationStatus];
    NSInteger photosAuth = [PrivacyCheckGatherTool photosAuthorizationStatus];
    NSString *cacheNum = [CacheTool showCache];
    
    NSString *typeString = @"无网络";
    if(self.networkType == 1){
        typeString = @"蜂窝";
    }else if(self.networkType == 2){
        typeString = @"WiFi";
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [self.dataArr addObjectsFromArray:@[
        @{Tab_Title:@"App名称",Tab_Flag:@0,Tab_Sub_Title:[infoDictionary objectForKey:@"CFBundleDisplayName"]},
        @{Tab_Title:@"App版本",Tab_Flag:@0,Tab_Sub_Title:[infoDictionary objectForKey:@"CFBundleShortVersionString"]},
        @{Tab_Title:@"App构建",Tab_Flag:@0,Tab_Sub_Title:[infoDictionary objectForKey:@"CFBundleVersion"]},
        @{Tab_Title:@"手机OS版本",Tab_Flag:@0,Tab_Sub_Title:[[UIDevice currentDevice] systemVersion]},
        @{Tab_Title:@"手机型号",Tab_Flag:@0,Tab_Sub_Title:[NSString getCurrentDeviceModel]},
        @{Tab_Title:@"手机别名",Tab_Flag:@0,Tab_Sub_Title:[[UIDevice currentDevice] name]},
        @{Tab_Title:@"手机UUID",Tab_Flag:@0,Tab_Sub_Title:[[UIDevice currentDevice] identifierForVendor]},
        ///下面可以点击跳转
        @{Tab_Title:@"允许访问定位权限",Tab_Flag:@(locationAuto),Tab_Sub_Title:[NSString stringWithFormat:@"用于需要获取位置信息的服务如查找营业部等(%@)",locationAuto == ECAuthorizationStatusAuthorized ?  @"已开启" : @"去设置"]},
        @{Tab_Title:@"允许访问推送权限",Tab_Flag:@(pushAuth),Tab_Sub_Title:[NSString stringWithFormat:@"用于接收APP通知推送消息等(%@)",pushAuth == ECAuthorizationStatusAuthorized ?  @"已开启" : @"去设置"]},
        @{Tab_Title:@"允许访问相机权限",Tab_Flag:@(cameraAuth),Tab_Sub_Title:[NSString stringWithFormat:@"用于拍照、扫描、录制视频等(%@)",cameraAuth == ECAuthorizationStatusAuthorized ?  @"已开启" : @"去设置"]},
        @{Tab_Title:@"允许访问相册权限",Tab_Flag:@(photosAuth),Tab_Sub_Title:[NSString stringWithFormat:@"用于图片、照片上传等(%@)",photosAuth == ECAuthorizationStatusAuthorized ?  @"已开启" : @"去设置"]},
        @{Tab_Title:@"允许访问网络权限",Tab_Flag:@(self.networkType),Tab_Sub_Title:[NSString stringWithFormat:@"用于数据请求、图片加载等(%@)",typeString]},
        @{Tab_Title:@"清除缓存",Tab_Flag:@998,Tab_Sub_Title:[NSString stringWithFormat:@"清除缓存后启动App会加载启动视频(%@)",cacheNum]},
        @{Tab_Title:@"日志是否为Json串打印",Tab_Flag:@999,Tab_Sub_Title:@"已关闭"},
        @{Tab_Title:@"切换logo",Tab_Flag:@997,Tab_Sub_Title:@"进入页面切换App的Logo"},
    ]];
    self.row = 7;//支持点击跳转的所在行数
    [self.tableView reloadData];
}

- (void)setUI{
    [self.bgView setHidden:YES];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    
    self.iconImage = [[UIImage alloc]init];
    self.iconImage = [UIImage imageNamed:@"moren.jpg"];
    self.tableView.tableFooterView = [self setUpTableFooterView];
    self.tableView.contentOffset = CGPointMake(0, -200);
}

#pragma mark -- createTopImageView
- (void)createTopImageView{
    //顶部试图
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -200, [UIScreen mainScreen].bounds.size.width, 200)];
    _topImageView.image = [UIImage imageNamed:@"biao.jpg"];
    //[_topImageView sd_setImageWithURL:[NSURL URLWithString:@"https://image.yiwencaifu.com/upload/20161202/1480654937932.jpg"] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    _topImageView.clipsToBounds = YES;
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    //始终保持原有宽高比例
    //添加到tableView上
    [self.tableView addSubview:_topImageView];
    //contentInset 额外滑动区域
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    //现在tableView的偏移量的y变成了-200
}

#pragma mark -- scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offSet = scrollView.contentOffset.y;
    NSLog(@"======= %f",offSet);

    CGFloat alll = offSet<-30 ? 0/200 : (fabsf(offSet)+200)/200;
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alll];
    NSLog(@">>>>>>> %f",alll);
    
    UIColor *color = [UIColor whiteColor];
    if (alll > 1) {
        color = [UIColor blackColor];
    }
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:color};
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else{
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    }
    
    if (offSet < -200) {
        //正在下拉
        //更新顶部试图的效果
        //1.图片始终顶在最上方
        //2.图片高度随下拉而增加
        CGRect rect = _topImageView.frame;  // (0, -200, SCREEN_W, 200)]
        rect.origin.y = offSet;
        rect.size.height = -offSet;
        //重置
        _topImageView.frame = rect;
    }
}

/* 组数 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
/* 行数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
/* cell内容 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.textLabel.text = dic[Tab_Title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", dic[Tab_Sub_Title]];
    if(indexPath.row >= self.row){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if([dic[Tab_Flag] intValue] == 999){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"【%@】",[[HsConfig readUserDefaultWithKey:kHsPrintLogJson] isEqualToString:@"1"] ? @"已开启" : @"已关闭"];
        }
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
/* 组头高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
/* 组尾高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
/* cell点击事件 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    if ([dic[Tab_Flag] intValue] == 3 && indexPath.row >= self.row) {
        [self goToSysSetting];
        return;
    }
    switch (indexPath.row - self.row) {
        case 0:{
            [self.privacyTool requestLocationAuthorizationWithCompletionHandler:^(ECAuthorizationStatus status) {
                KLog(@"本次回调只有在第一次系统提醒授权的时候才有用!之后还是需要调用pageActivityStart!");
                [self initData];
            }];
        }
            break;
            
        case 1:{
            // 通知
            [PrivacyCheckGatherTool requestPushAuthorizationWithCompletionHandler:^{
                KLog(@"本次回调只有在第一次系统提醒授权的时候才有用!之后还是需要调用pageActivityStart!");
                [self initData];
            }];
        }
            break;
        case 2:{
            //访问相机
            [PrivacyCheckGatherTool requestCameraAuthorizationWithCompletionHandler:^(BOOL granted) {
                KLog(@"本次回调只有在第一次系统提醒授权的时候才有用!之后还是需要调用pageActivityStart!");
                [self initData];
            }];
        }
            break;
        case 3:{
            //访问相册
            [PrivacyCheckGatherTool requestPhotosAuthorizationWithCompletionHandler:^(BOOL granted) {
                KLog(@"本次回调只有在第一次系统提醒授权的时候才有用!之后还是需要调用pageActivityStart!");
                [self initData];
            }];
        }
            break;
        case 4:{
            //网络请求
            [self goToSysSetting];
        }
            break;
        case 5:{
            //清除缓存
            WS(weakSelf);
            [AlertControTool alertTitle:@"温馨提示" andMessage:@"确定删除所有缓存?" andAction1:@"取消" andAction2:@"确定" andBlock:^(NSInteger errorCode) {
                if (errorCode == 0) {
                    [CacheTool clearCache];
                    [HsConfig writeUserDefaultWithKey:VersionCache WithValue:@"123"];
                    [DDToast showToast:@"清除成功!"];
                    [weakSelf initData];
                }
            }];
            
        }
            break;
        case 6:{
            // 日志是否为Json串打印
            if([[HsConfig readUserDefaultWithKey:kHsPrintLogJson] isEqualToString:@"1"]){
                [HsConfig writeUserDefaultWithKey:kHsPrintLogJson WithValue:@"0"];
            }else{
                [HsConfig writeUserDefaultWithKey:kHsPrintLogJson WithValue:@"1"];
            }
            [self.tableView reloadData];
        }
            break;
            
        case 7:{
            UIViewController *vController = [[NSClassFromString(@"ChangeLogoViewController") alloc] init];
            vController.hidesBottomBarWhenPushed = YES;
            vController.title = @"切换Logo";
            [[[GetTopVCTool shareInstance] topViewController].navigationController pushViewController:vController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.preservesSuperviewLayoutMargins = NO;
}

- (void)viewDidLayoutSubviews {
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}

- (UIView *)setUpTableFooterView{
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, KScreenW, 200);
    
    UIImageView *iconIv = [[UIImageView alloc] init];
    [headerView addSubview:iconIv];
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerView.mas_centerX);
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.width.height.mas_equalTo(100);
    }];
    iconIv.image = self.iconImage;
    //设置圆角
    iconIv.layer.masksToBounds = YES;
    iconIv.layer.cornerRadius = 10;
    //增加可交互性
    iconIv.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *lGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lGREvent:)];
    lGR.minimumPressDuration = 2;
    [iconIv addGestureRecognizer:lGR];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = @"(长按上方icon可以保存到相册内)";
    desLab.font = [UIFont systemFontOfSize:14];
    desLab.textColor = UIColorFromRGB(0x696969);
    [headerView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(iconIv.mas_centerX);
        make.top.mas_equalTo(iconIv.mas_bottom).offset(10);
    }];
    
    return headerView;
}

- (void)goToSysSetting {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    });
}

- (void)lGREvent:(UIGestureRecognizer *)tapGR{
    if(tapGR.state == UIGestureRecognizerStateBegan){
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:self.iconImage];
            changeRequest.creationDate          = [NSDate date];
        } completionHandler:^(BOOL success, NSError *error) {
            if (success) {
                [DDToast showToast:@"照片保存成功!"];
            }else {
                [DDToast showToast:@"照片保存失败!"];
            }
        }];
    }
}

- (void)requestNetwork{
    WS(weakSelf);
    [PrivacyCheckGatherTool requestNetworkAuthorizationWithCompletionHandler:^(NSInteger type) {
        KLog(@"实时监测网络状态!");
        weakSelf.networkType = type;
        [weakSelf initData];
    }];
}

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (PrivacyCheckGatherTool *)privacyTool {
    if (!_privacyTool) {
        _privacyTool = [[PrivacyCheckGatherTool alloc] init];
    }
    return _privacyTool;
}

@end
