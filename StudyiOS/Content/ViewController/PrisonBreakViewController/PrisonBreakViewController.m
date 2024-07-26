//
//  PrisonBreakViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/7/26.
//



#import "PrisonBreakViewController.h"

#define USER_APP_PATH @"/User/Applications/"

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};


@interface PrisonBreakViewController ()


@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;



@end

@implementation PrisonBreakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view sendSubviewToBack:self.bgView];
    KViewRadius(self.btn1, CGRectGetHeight(self.btn1.frame)/2.0);
    KViewRadius(self.btn2, CGRectGetHeight(self.btn2.frame)/2.0);
    KViewRadius(self.btn3, CGRectGetHeight(self.btn3.frame)/2.0);
}

- (IBAction)btnClick:(UIButton *)sender {
    if (sender == self.btn1) {
        if ([self isJailBreak1]) {
            [DDToast showToast:@"该设备已越狱,小心使用🕷"];
        }else{
            [DDToast showToast:@"该设备未越狱,请放心使用!"];
        }
    }else if (sender == self.btn2) {
        if ([self isJailBreak2]) {
            [DDToast showToast:@"该设备已越狱,小心使用🕷"];
        }else{
            [DDToast showToast:@"该设备未越狱,请放心使用!"];
        }
    }else if (sender == self.btn3) {
        if ([self isJailBreak3]) {
            [DDToast showToast:@"该设备已越狱,小心使用🕷"];
        }else{
            [DDToast showToast:@"该设备未越狱,请放心使用!"];
        }
    }
}

- (BOOL)isJailBreak1 {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isJailBreak2 {
    NSArray *pathArr = [[NSArray alloc] initWithObjects: @"/Applications/Cydia.app", @"/usr/sbin/sshd", @"/etc/apt", nil];
    for (int i = 0 ; i < pathArr.count ; i ++) {
        NSString *path = pathArr[i];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isJailBreak3 {
    if ([[NSFileManager defaultManager] fileExistsAtPath:USER_APP_PATH]) {
        NSArray *applist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:USER_APP_PATH error:nil];
        return YES;
    }
    return NO;
    
    //    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
    //        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
    //            return YES;
    //        }
    //    }
    //    return NO;
}


@end
