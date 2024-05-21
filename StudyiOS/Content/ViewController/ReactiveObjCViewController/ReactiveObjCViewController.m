//
//  ReactiveObjCViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/2/6.
//

#import "ReactiveObjCViewController.h"

@interface ReactiveObjCViewController ()

@property (nonatomic,strong) UITextField *userTextField;


@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;

@property (weak, nonatomic) IBOutlet UITextField *redTF;
@property (weak, nonatomic) IBOutlet UITextField *blueTF;
@property (weak, nonatomic) IBOutlet UITextField *greenTF;

@property (weak, nonatomic) IBOutlet UIView *colorview;

@end

@implementation ReactiveObjCViewController

- (UITextField *)userTextField{
    if(_userTextField == nil){
        _userTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, KTopHeight+5, KScreenW-20, 50)];
        _userTextField.placeholder = @"请输入用户名";
    }
    return _userTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //示例1
    [self.view addSubview:self.userTextField];
    [self.userTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        KLog(@"实时输入:%@",x);
    }];
    
    //示例2 颜色选择器
    self.redTF.text = self.blueTF.text = self.greenTF.text = @"0.5";
    RACSignal *redSignal = [self blindSlider:self.redSlider textField:self.redTF];
    RACSignal *blueSignal = [self blindSlider:self.blueSlider textField:self.blueTF];
    RACSignal *greenSignal = [self blindSlider:self.greenSlider textField:self.greenTF];
    //方式一
    //⚠️: RAC所有回调都不是主线程,所有UI刷新需要在主线程执行
    //    [[[RACSignal combineLatest:@[redSignal,blueSignal,greenSignal]]map:^id _Nullable(RACTuple * _Nullable value) {
    //        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[1] floatValue] alpha:1];
    //    }] subscribeNext:^(id  _Nullable x) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.colorview.backgroundColor = x;
    //        });
    //    }];
    //方式二
    RACSignal *changeValueSignal = [[RACSignal combineLatest:@[redSignal,blueSignal,greenSignal]]map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[1] floatValue] alpha:1];
    }];
    RAC(self.colorview,backgroundColor) = changeValueSignal;
}

- (RACSignal *)blindSlider:(UISlider *)slider textField:(UITextField *)textField{
    RACSignal *textSignal = [[textField rac_textSignal]take:1];//只触发一次
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    [signalText subscribe:signalSlider];
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.2f",[value floatValue]];
    }] subscribe:signalText];
    
    return [[signalText merge:signalSlider] merge:textSignal];
}

@end
