//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYHeader.h"

@interface MJDIYHeader()
@property (weak, nonatomic) UIActivityIndicatorView *activityView;
@property (weak, nonatomic) UIImageView *customArrow;
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *backGroundImageView;
@end

@implementation MJDIYHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 80;
    
    // 添加刷新中的菊花
    UIActivityIndicatorView *activityImV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    [activityImV startAnimating];
    [self addSubview:activityImV];
    self.activityView = activityImV;
    
    // 添加下拉刷新状态箭头
    UIImage *arrowImg = [UIImage imageNamed:@"Icon_Refresh_Arrow@2x.png"];
    UIImageView *customArrow = [[UIImageView alloc] initWithImage:arrowImg];
    [self addSubview:customArrow];
    self.customArrow = customArrow;
    
    // 添加刷新状态label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // 添加刷新背景图片
    UIImage *backGroundImage = [UIImage imageNamed:@"Icon_Refresh.png"];//
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithImage:backGroundImage];
    [self addSubview:backGroundImageView];
    self.backGroundImageView = backGroundImageView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    self.backGroundImageView.bounds = CGRectMake(0, 0, 132, 44);
    self.backGroundImageView.center = CGPointMake(self.mj_w * 0.5, - self.backGroundImageView.mj_h + 70);
    
    CGFloat bottom = self.backGroundImageView.frame.origin.y + self.backGroundImageView.frame.size.height + 5;
    
    self.customArrow.frame = CGRectMake(self.bounds.size.width/2 - 40, bottom, 20, 20);
    self.activityView.frame = CGRectMake(self.bounds.size.width/2 - 40, bottom, 20, 20);
    
    self.label.frame = CGRectMake(self.customArrow.frame.origin.x + 10 , bottom, 80, 20);
    

}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];

}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];

}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            
            self.label.text = @"下拉刷新";
            self.customArrow.hidden = NO;
            self.activityView.hidden = YES;
            break;
        case MJRefreshStatePulling:
            
            self.label.text = @"释放刷新";
            [self rotateArrow:M_PI hide:NO];
            break;
        case MJRefreshStateRefreshing:
            
            [self rotateArrow:M_PI hide:YES];
            self.label.text = @"正在刷新";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    
    
    NSLog(@"----------%lf",pullingPercent);
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    if (self.customArrow) {
        if (hide) {
            [self.customArrow setHidden:YES];
            [self.activityView setHidden:NO];
        } else {
            [self.customArrow setHidden:NO];
            [self.activityView setHidden:YES];
        }
        
        [UIView animateWithDuration:.2 animations:^{
            self.customArrow.transform = CGAffineTransformRotate(self.customArrow.transform, -degrees);
        }];
    }
}

@end
