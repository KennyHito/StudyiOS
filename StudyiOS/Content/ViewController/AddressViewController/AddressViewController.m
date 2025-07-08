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
    kWeakify(self)
    [self.view createButtonTitle:@"选择地址" andFont:20 andTitleColor:[UIColor whiteColor] andBackgroundColor:[UIColor redColor] andFrame:CGRectMake((KScreenW-200)/2, 100, 200, 50) actionBlock:^(UIButton * _Nonnull button) {
        KStrongify(self)
        [self.threePicker showAddress];
        self.threePicker.completion = ^(NSString *address, NSString * addressCode){
            KLog(@"_threePicker\n, address=%@, addressCode=%@\n\n", address, addressCode);
            [DDToast showToast:address];
        };
    }];
}

- (RXJDAddressPickerView *)threePicker{
    if(!_threePicker){
        _threePicker = [[RXJDAddressPickerView alloc] init];
        [self.view addSubview:_threePicker];
    }
    return _threePicker;
}

@end
