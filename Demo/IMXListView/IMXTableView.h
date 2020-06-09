//
//  IMXTableView.h
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/11/29.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMXListViewDefine.h"
@interface IMXTableView : UITableView
/**
 只允许上拉、下拉之一执行
 */
@property (nonatomic,assign)BOOL permitOnlyOneRefresh;


/**
 启动下拉刷新

 @param block 刷新回调
 */
- (void)pullRefresh:(imxListRefreshBlock)block;
/**
 启动上拉刷新
 
 @param block 刷新回调
 */
- (void)loadMore:(imxListRefreshBlock)block;

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
