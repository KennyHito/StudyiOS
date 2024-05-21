//
//  CustomCollectionViewCell.m
//  StudyiOS
//
//  Created by Apple on 2023/10/31.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UIButton *)btn{
    if(!_btn){
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.layer.cornerRadius = 3;
        _btn.layer.masksToBounds = YES;
        _btn.layer.borderColor = [UIColor blackColor].CGColor;
        _btn.layer.borderWidth = 1;
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _btn;
}

@end
