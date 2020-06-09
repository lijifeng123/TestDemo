//
//  UIScrollView+XS_RefreshUIScrollView.h
//  Demo
//
//  Created by lijifeng on 2020/5/12.
//  Copyright © 2020 Musk Ronaldo Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XSListRefreshBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (XSRefresh)

/**
 * 是否开启上下拉刷新
 */
@property (nonatomic,assign)BOOL openRefresh;

/**
 只允许上拉、下拉之一执行
 */
@property (nonatomic,assign)BOOL permitOnlyOneRefresh;


/**
 启动下拉刷新

 @param block 刷新回调
 */
- (void)pullRefresh:(XSListRefreshBlock)block;
/**
 启动上拉刷新
 
 @param block 刷新回调
 */
- (void)loadMore:(XSListRefreshBlock)block;

/**
 手动使能下拉刷新
 */
- (void)beginPullRefresh;

/**
 结束下拉刷新
 */
- (void)endPullRefresh;
/**
 结束上拉刷新
 */
- (void)endPullLoadmore;
/**
 上拉刷新：无更多数据
 */
- (void)noticeNoMoreData;
/**
 上拉刷新：重置
 */
- (void)resetNoMoreData;

/**
 是否自动隐藏底部无数据提示

 @param isHide 布尔值
 */
- (void)autoNoMoreDataTips:(BOOL)isHide;
/**
 结束下拉&&上拉刷新
 */
- (void)endPullAllRefresh;
- (void)resetFooterIdle;
- (void)refreshStatusWhenNextPageHasError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
