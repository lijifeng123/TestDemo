//
//  IMXSingleTextTableCell.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/7.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXSingleTextTableCell.h"
#import <Masonry/Masonry.h>

@interface IMXSingleTextTableCell()
@property (nonatomic,strong)UILabel *tipsLB;

@property (nonatomic,assign)UIEdgeInsets insets;
@end

@implementation IMXSingleTextTableCell

- (void)dealloc{
}
#pragma mark ======  public  ======
- (void)loadCell:(NSAttributedString *)astring{
    self.tipsLB.attributedText = astring;
}
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width{
    CGSize size = [astring boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat height = MAX(20, size.height);
    return ceil(height+0.5+0.5);//line
}
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width insets:(UIEdgeInsets)insets{
    CGSize size = [astring boundingRectWithSize:CGSizeMake(width-insets.left-insets.right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat height = MAX(20, size.height);
    height += insets.top+insets.bottom;
    return ceil(height+0.5+0.5);//line
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier insets:(UIEdgeInsets)insets{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUIs];
        self.insets = insets;
        [self refreshUIs];
    }
    return self;
}
+ (CGFloat)cellHeight{
    return 44.0f;
}
#pragma mark ======  life cycle  ======
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUIs];
        self.insets = UIEdgeInsetsMake(0, 15, 0, 15);
        [self refreshUIs];
    }
    return self;
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======
- (void)configUIs{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.tipsLB];
}
- (void)refreshUIs{
    [self.tipsLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.insets.left);
        make.top.equalTo(self.contentView).offset(self.insets.top+0.5);
        make.right.equalTo(self.contentView).offset(-self.insets.right);
        make.bottom.equalTo(self.contentView).offset(-self.insets.bottom-0.5);
    }];
}
#pragma mark ======  getter & setter  ======
- (UILabel *)tipsLB{
    if(!_tipsLB){
        _tipsLB = [UILabel new];
        _tipsLB.numberOfLines = 0;
    }
    return _tipsLB;
}
- (void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
    
    self.backgroundColor = backColor;
    self.contentView.backgroundColor = backColor;
}
@end
