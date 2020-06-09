//
//  IMXBaseCollectionViewCell.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXBaseCollectionViewCell.h"
#import "IMXLineView.h"
#import <Masonry/Masonry.h>

@interface IMXBaseCollectionViewCell()
@property (nonatomic, strong) IMXLineView * topLineView;
@property (nonatomic, strong) IMXLineView * bottomLineView;
@property (nonatomic, strong) IMXLineView * leftLineView;
@property (nonatomic, strong) IMXLineView * rightLineView;
@end

@implementation IMXBaseCollectionViewCell

- (void)dealloc{
}
#pragma mark ======  public  ======
+ (NSString *)IMXReuseID{
    return NSStringFromClass([self class]);
}
+ (CGFloat)cellHeight{
    return 0;
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
- (void)showLeftLine:(UIEdgeInsets)insets{
    if(!self.leftLineView.superview){
        [self.contentView addSubview:self.leftLineView];
    }
    [self.leftLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.bottom.equalTo(self.contentView).offset(-insets.bottom);
        make.top.equalTo(self.contentView).offset(insets.top);
        make.leading.equalTo(self.contentView).offset(insets.left);
    }];
    self.leftLineView.hidden = NO;
}
- (void)hideLeftLine{
    self.bottomLineView.hidden = YES;
}
- (void)showRightLine:(UIEdgeInsets)insets{
    if(!self.rightLineView.superview){
        [self.contentView addSubview:self.rightLineView];
    }
    [self.rightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.bottom.equalTo(self.contentView).offset(-insets.bottom);
        make.top.equalTo(self.contentView).offset(insets.top);
        make.trailing.equalTo(self.contentView).offset(-insets.right);
    }];
    self.rightLineView.hidden = NO;
}
- (void)hideRightLine{
    self.rightLineView.hidden = YES;
}
#pragma mark ======  life cycle  ======
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
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
- (IMXLineView *)leftLineView{
    if(!_leftLineView){
        _leftLineView=[[IMXLineView alloc] initWithFrame:CGRectZero];
        _leftLineView.lineColor= [UIColor colorWithRed:246/255.0 green:246/255.0 blue:241/255.0 alpha:1.0];
        _leftLineView.hidden=YES;
    }
    return _leftLineView;
}
- (IMXLineView *)rightLineView{
    if(!_rightLineView){
        _rightLineView=[[IMXLineView alloc] initWithFrame:CGRectZero];
        _rightLineView.lineColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:241/255.0 alpha:1.0];
        _rightLineView.hidden=YES;
    }
    return _rightLineView;
}

@end
