//
//  XSMJDIYHeader.m
//  Demo
//
//  Created by lijifeng on 2020/5/13.
//  Copyright © 2020 Musk Ronaldo Ming. All rights reserved.
//

#import "XSMJDIYHeader.h"
#import <Lottie/Lottie.h>
#import "UIView+FrameExtension.h"

#define MaxImageH 40
#define MinImageH 28

@interface XSMJDIYHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *backGroundImageView;
@property (weak, nonatomic) LOTAnimationView *lottieLogo;

@end

@implementation XSMJDIYHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 100;
    
    // 添加刷新状态label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // 添加刷新背景图片
    LOTAnimationView *lottieView = [LOTAnimationView animationNamed:@"XSPullRefresh"];
    lottieView.loopAnimation = YES;
    lottieView.animationSpeed = 1.2;
    lottieView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:lottieView];
    self.lottieLogo = lottieView;
    MJWeakSelf;
    self.endRefreshingCompletionBlock = ^{
        weakSelf.label.text = @"下拉刷新";
        [weakSelf.lottieLogo stop];
    };
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.pullingPercent == 0) {
        self.lottieLogo.frame = CGRectMake(0, self.label.mj_y - 10 - MaxImageH, MaxImageH, MaxImageH);
        self.lottieLogo.centerX = self.label.centerX;
    }
    
    self.label.frame = CGRectMake((self.mj_w - 80) / 2 , self.mj_h - 20, 80, 10);
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
            
            if (self.label.text.length > 0) {
                self.label.text = @"刷新中";
            }else{
                self.label.text = @"下拉刷新";
            }
            break;
        case MJRefreshStatePulling:
            
            self.label.text = @"松开刷新";
            [self.lottieLogo stop];
            break;
        case MJRefreshStateRefreshing:
            
            self.label.text = @"刷新中";
            [self.lottieLogo play];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    if (self.pullingPercent == 0) {
        return;
    }

    CGFloat imageHeight = 0;
    
    if (self.pullingPercent < 0.6) {
        imageHeight = MinImageH;
    }else if (self.pullingPercent < 1) {
        imageHeight = (MaxImageH - MinImageH) /0.4 * (pullingPercent - 0.6) + MinImageH;
    }else{
        imageHeight = MaxImageH;
    }
    
    self.lottieLogo.frame = CGRectMake(0, self.label.mj_y - 10 - imageHeight, imageHeight, imageHeight);
    self.lottieLogo.centerX = self.label.centerX;
    
    NSLog(@"------%lf",pullingPercent);
}

@end
