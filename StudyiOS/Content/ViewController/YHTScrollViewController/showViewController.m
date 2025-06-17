//
//  showViewController.m
//  Summarize
//
//  Created by KennyHito on 16/12/17.
//  Copyright © 2016年 KennyHito. All rights reserved.
//

#import "showViewController.h"

@interface showViewController ()

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *WhereLabel;
@property (weak, nonatomic) IBOutlet UILabel *VenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *ShowTimeLabel;

@property (nonatomic,weak) MenuModel * mod;

@end

@implementation showViewController

-(void)sendDataArr:(MenuModel *)model{
    _mod = model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详情";
    
    self.NameLabel.text = _mod.ID;
    self.WhereLabel.text = _mod.name;
    self.VenNameLabel.text = _mod.created_at;
    self.priceNameLabel.text = _mod.content;
    self.PriceStrLabel.text = _mod.origin;
    self.ShowTimeLabel.text = _mod.tag;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
