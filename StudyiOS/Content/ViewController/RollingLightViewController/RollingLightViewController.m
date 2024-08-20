//
//  RollingLightViewController.m
//  StudyiOS
//
//  Created by Apple on 2024/8/19.
//

#import "RollingLightViewController.h"

@interface RollingLightViewController ()
@property (nonatomic,strong) CBAutoScrollLabel *autoScrollLabel;
@end

@implementation RollingLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.autoScrollLabel.frame = CGRectMake(10, 0, KScreenW-20, 20);
    [self.bgView addSubview:self.autoScrollLabel];
}

- (CBAutoScrollLabel *)autoScrollLabel{
    if (!_autoScrollLabel) {
        _autoScrollLabel = [[CBAutoScrollLabel alloc]init];
        _autoScrollLabel.textColor = UIColorFromRGB(0x41210f);
        _autoScrollLabel.font = [UIFont systemFontOfSize:14];
        _autoScrollLabel.text = @"习近平指出，你这次来华首站到访广东，很有意义。100年前，胡志明主席赴广州开展革命活动，他的革命足迹遍布中国多地，最终领导越南取得八月革命胜利，实现国家独立。那段峥嵘岁月成为中越两党交往史中不可磨灭的红色记忆，共同的理想信念成为中越两党血脉中代代传承的红色基因，凝结成“越中情谊深，同志加兄弟”的传统友谊。苏林说：“这是我当选越共中央总书记后的第一次出访，也是我当选后首次访问中国，充分体现出越南党和国家一贯重视对华关系，视之为越南对外政策的战略选择和头等优先。我与越南党政高层领导集体，非常愿意同习近平总书记、国家主席同志及中国党政高层领导不断培育友好传统，进一步深化和提升全面战略合作伙伴关系。作为同志加兄弟，我们始终关心并关注中国的每一步发展。我们再次强调，越南坚定奉行一个中国政策，台湾是中国领土不可分割的一部分。”";
        [_autoScrollLabel observeApplicationNotifications];
    }
    return _autoScrollLabel;
}

@end
