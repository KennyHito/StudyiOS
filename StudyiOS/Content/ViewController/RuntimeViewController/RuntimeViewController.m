//
//  RuntimeViewController.m
//  StudyiOS
//
//  Created by Apple on 2023/10/19.
//

#import "RuntimeViewController.h"

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// forwardingTargetForSelector
    Person *xiaoming = [[Person alloc]init];
    [xiaoming performSelector:@selector(eat)];
    [xiaoming performSelector:@selector(play:) withObject:@"小明"];
    [xiaoming performSelector:@selector(more:) withObject:@{@"age":@19,@"name":@"小明"}];
    [xiaoming performSelector:@selector(run)];
    Car *aoDi = [Car callObjectTarget:xiaoming];
    [aoDi performSelector:@selector(diuCar)];
}

@end
