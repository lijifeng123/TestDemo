//
//  UIScrollView+XS_RefreshUIScrollView.h
//  Demo
//
//  Created by lijifeng on 2020/5/12.
//  Copyright © 2020 Musk Ronaldo Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

typedef void(^XSListRefreshBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (XSRefresh)

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
 上拉刷新：无更多数据 默认无底部展示信息，noDataTip：有值展示底部信息
 */
- (void)noticeNoMoreData;
- (void)noticeNoMoreData:(NSString *)noDataTip;
/**
 上拉刷新：重置
 */
- (void)resetNoMoreData;
/**
 结束下拉&&上拉刷新
 */
- (void)endPullAllRefresh;
- (void)resetFooterWithContent:(NSString *)content state:(MJRefreshState)state;
- (void)refreshStatusWhenNextPageHasError:(NSError *)error;
/**
* 是否开启上下拉刷新 隐藏header footer 以及内容
*/

- (void)openPullRefresh:(BOOL)hideHeader DEPRECATED_MSG_ATTRIBUTE("为了兼容旧版本刷新，使用新版本方法无需调用");
- (void)openLoadMoreRefresh:(BOOL)hideFooter DEPRECATED_MSG_ATTRIBUTE("为了兼容旧版本刷新，使用新版本方法无需调用");

/**
 只允许上拉、下拉之一执行
 */
@property (nonatomic,assign)BOOL permitOnlyOneRefresh;

@property (nonatomic) CGFloat xsTriggerAutomaticallyRefreshPercent;

@end

NS_ASSUME_NONNULL_END
