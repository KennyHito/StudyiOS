//
//  AddressViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/11/7.
//

#import "AddressViewController.h"
#import "RXJDAddressPickerView.h"
@interface AddressViewController ()
@property (nonatomic,strong) RXJDAddressPickerView * threePicker;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [self createButtonTitle:@"选择地址" andFont:15 andTitleColor:[UIColor yellowColor] andBackColor:[UIColor redColor] andTag:100 andFrame:CGRectMake(KScreenW/2-50, 100, 100, 40)];
    [self.view addSubview:btn];
}

/* UIButton封装 */
- (UIButton *)createButtonTitle:(NSString *)title andFont:(int)size andTitleColor:(UIColor *)titleColor andBackColor:(UIColor *)backColor andTag:(int)tag andFrame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:size]];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn setFrame:frame];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:4.0];
    btn.backgroundColor = backColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnClick:(UIButton *)btn{
    [self.threePicker showAddress];
    self.threePicker.completion = ^(NSString *address, NSString * addressCode){
        KLog(@"_threePicker\n, address=%@, addressCode=%@\n\n", address, addressCode);
        [DDToast showToast:address];
    };
}

- (RXJDAddressPickerView *)threePicker{
    if(!_threePicker){
        _threePicker = [[RXJDAddressPickerView alloc] init];
        [self.view addSubview:_threePicker];
    }
    return _threePicker;
}

@end
