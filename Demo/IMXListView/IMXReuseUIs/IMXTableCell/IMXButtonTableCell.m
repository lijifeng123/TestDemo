//
//  IMXButtonTableCell.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXButtonTableCell.h"
#import <Masonry/Masonry.h>
@interface IMXButtonTableCell()
@property(nonatomic, strong)UIButton *button;
@property(nonatomic, assign) UIEdgeInsets buttonInset;
@end

@implementation IMXButtonTableCell

- (void)dealloc{
}
#pragma mark ======  public  ======
- (instancetype)initWithInset:(UIEdgeInsets)inset cellStyle:(UITableViewCellStyle)style  btn:(id)btn reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.buttonInset = inset;
        self.button = btn;
        if(!btn){
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.button.titleLabel setFont:[UIFont imx_helNeueFont:18.0f]];
        }
        [self.contentView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(inset.left);
            make.right.equalTo(self.contentView).offset(-inset.right);
            make.bottom.equalTo(self.contentView).offset(inset.bottom);
            make.top.equalTo(self.contentView).offset(inset.top);
        }];
    }
    
    return self;
}
- (void)updateCell{
    [self.button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:self.btnTitle forState:UIControlStateNormal];
}
- (CGFloat)singleCellHeight {
    return 44.0f + self.buttonInset.top + self.buttonInset.bottom;
}
- (void)enableBtn:(BOOL)enable{
    self.button.enabled = enable;
}
#pragma mark ======  life cycle  ======
- (void)prepareForReuse {
    [super prepareForReuse];
    [self.button removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======
- (void)btnClicked:(UIButton *)btn {
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}

#pragma mark ======  getter & setter  ======



@end
