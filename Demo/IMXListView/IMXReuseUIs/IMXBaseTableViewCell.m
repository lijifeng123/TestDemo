//
//  IMXBaseTableViewCell.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXBaseTableViewCell.h"
//#import "IMXLineView.h"
#import <Masonry/Masonry.h>
@interface IMXBaseTableViewCell()
//@property (nonatomic, strong) IMXLineView * topLineView;
//@property (nonatomic, strong) IMXLineView * bottomLineView;
@end
@implementation IMXBaseTableViewCell

- (void)dealloc{
}
#pragma mark ======  public  ======
+ (NSString *)IMXReuseID{
    return NSStringFromClass([self class]);
}
- (void)showTopLine:(UIEdgeInsets)insets{
    if(!self.topLineView.superview){
        [self.contentView addSubview:self.topLineView];
    }
    [self.topLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.top.equalTo(self.contentView).offset(insets.top);
        make.leading.equalTo(self.contentView).offset(insets.left);
        make.trailing.equalTo(self.contentView).offset(-insets.right);
    }];
    self.topLineView.hidden = NO;
}
- (void)hideTopLine{
    self.topLineView.hidden = YES;
}
- (void)showBottomLine:(UIEdgeInsets)insets{
    if(!self.bottomLineView.superview){
        [self.contentView addSubview:self.bottomLineView];
    }
    [self.bottomLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.bottom.equalTo(self.contentView).offset(-insets.bottom);
        make.leading.equalTo(self.contentView).offset(insets.left);
        make.trailing.equalTo(self.contentView).offset(-insets.right);
    }];
    self.bottomLineView.hidden = NO;
}
- (void)hideBottomLine{
    self.bottomLineView.hidden = YES;
}
//need overwrite
- (CGFloat)singleCellHeight{
    return 0;
}
+ (CGFloat)cellHeight{
    return 0;
}
#pragma mark ======  life cycle  ======
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======

#pragma mark ======  getter & setter  ======
- (IMXLineView *)topLineView{
    if(!_topLineView){
        _topLineView=[[IMXLineView alloc] initWithFrame:CGRectZero];
        _topLineView.lineColor= [UIColor colorWithRed:246/255.0 green:246/255.0 blue:241/255.0 alpha:1.0];
        _topLineView.hidden=YES;
    }
    return _topLineView;
}
- (IMXLineView *)bottomLineView{
    if(!_bottomLineView){
        _bottomLineView=[[IMXLineView alloc] initWithFrame:CGRectZero];
        _bottomLineView.lineColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:241/255.0 alpha:1.0];
        _bottomLineView.hidden=YES;
    }
    return _bottomLineView;
}
@end
