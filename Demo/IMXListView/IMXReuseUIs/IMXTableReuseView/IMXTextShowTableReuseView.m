//
//  IMXTextShowTableReuseView.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/20.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXTextShowTableReuseView.h"
#import <Masonry/Masonry.h>
@interface IMXTextShowTableReuseView()
@property (nonatomic,strong)UILabel *textLB;
@end
@implementation IMXTextShowTableReuseView

- (void)dealloc{
}
#pragma mark ======  public  ======
- (void)loadCell:(NSAttributedString *)astring{
    self.textLB.attributedText = astring;
}
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width{
    return [self cellHeight:astring fixWidth:width insets:UIEdgeInsetsZero];
}
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width insets:(UIEdgeInsets)insets{
    CGSize size = [astring boundingRectWithSize:CGSizeMake(width-insets.left-insets.right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat height = MAX(20, size.height);
    height += insets.top+insets.bottom;
    return ceil(size.height);//line
}
+ (CGFloat)cellHeight{
    return 44.0f;
}
#pragma mark ======  life cycle  ======
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUIs];
        [self refreshUIs];
    }
    return self;
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======
- (void)configUIs{
    [self.contentView addSubview:self.textLB];
}
- (void)refreshUIs{
    [self.textLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.insets.left);
        make.top.equalTo(self.contentView).offset(self.insets.top);
        make.right.equalTo(self.contentView).offset(-self.insets.right);
        make.bottom.equalTo(self.contentView).offset(-self.insets.bottom);
    }];
}
#pragma mark ======  getter & setter  ======
- (UILabel *)textLB{
    if(!_textLB){
        _textLB = [UILabel new];
        _textLB.numberOfLines = 0;
    }
    return _textLB;
}
- (void)setInsets:(UIEdgeInsets)insets{
    _insets = insets;
    [self refreshUIs];
}
- (void)setImx_backgroudColor:(UIColor *)imx_backgroudColor{
    _imx_backgroudColor = imx_backgroudColor;
    self.backgroundColor = imx_backgroudColor;
    self.contentView.backgroundColor = imx_backgroudColor;
}

@end
