//
//  IMXTableView.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/11/29.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXTableView.h"
#import <MJRefresh/MJRefresh.h>
@interface IMXTableView()
@property (nonatomic,copy)imxListRefreshBlock pullRefreshBlock;
@property (nonatomic,copy)imxListRefreshBlock loadMoreBlock;
@end
@implementation IMXTableView

- (void)dealloc{
}
#pragma mark ======  public  ======
- (void)pullRefresh:(imxListRefreshBlock)block
{
    self.pullRefreshBlock = block;
    if(block)
    {
        if(self.mj_header)
        {
            return;
        }
        __weak __typeof(self) weakSelf = self;
        self.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            __strong __typeof(weakSelf)strongself = weakSelf;
            if(strongself.permitOnlyOneRefresh){
                if(self.mj_footer && self.mj_footer.refreshing){
                    [strongself endPullRefresh];
                }else{
                    [strongself resetNoMoreData];
                    strongself.pullRefreshBlock();
                }
            }else{
                [strongself resetNoMoreData];
                strongself.pullRefreshBlock();
            }
        }];
        self.mj_header.ignoredScrollViewContentInsetTop = 0;
        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.mj_header;
        header.lastUpdatedTimeLabel.hidden = YES;
    }
    else
    {
        self.mj_header = nil;
    }
    
}
- (void)loadMore:(imxListRefreshBlock)block
{
    self.loadMoreBlock = block;
    
    if(block)
    {
        if(self.mj_footer)
        {
            return;
        }
        __weak __typeof(self) weakSelf = self;
        
        self.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if(strongSelf.permitOnlyOneRefresh){
                if(self.mj_header && self.mj_header.refreshing){
                    [strongSelf endPullLoadmore];
                }else{
                    strongSelf.loadMoreBlock();
                }
            }else{
                strongSelf.loadMoreBlock();
            }
        }];
        MJRefreshAutoStateFooter *autoFooter = (MJRefreshAutoStateFooter *)self.mj_footer;
        autoFooter.triggerAutomaticallyRefreshPercent = -1.0;
    }
    else
    {
        self.mj_footer = nil;
    }
}
- (void)beginPullRefresh
{
    [self.mj_header beginRefreshing];
}
- (void)endPullRefresh
{
    [self.mj_header endRefreshing];
}
- (void)endPullLoadmore
{
    [self.mj_footer endRefreshing];
}
- (void)noticeNoMoreData
{
    if(self.loadMoreBlock)
    {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}
- (void)resetNoMoreData
{
    [self.mj_footer resetNoMoreData];
}
- (void)autoNoMoreDataTips:(BOOL)isHide{
    self.mj_footer.hidden = isHide;
}
- (void)endPullAllRefresh
{
    if(self.pullRefreshBlock)
    {
        [self endPullRefresh];
    }
    if(self.loadMoreBlock)
    {
        [self endPullLoadmore];
    }
}
- (void)resetFooterIdle
{
    //[self.mj_footer setTitle:@"奋力加载中..." forState:MJRefreshStateIdle];
}
- (void)refreshStatusWhenNextPageHasError:(NSError *)error
{
    [self endPullAllRefresh];
    
    if(self.loadMoreBlock)
    {
        //[self.mj_footer setTitle:@"加载失败,请重试～" forState:MJRefreshStateIdle];
    }
}

#pragma mark ======  life cycle  ======

#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======

#pragma mark ======  getter & setter  ======



@end
