//
//  UIScrollView+XS_RefreshUIScrollView.m
//  Demo
//
//  Created by lijifeng on 2020/5/12.
//  Copyright © 2020 Musk Ronaldo Ming. All rights reserved.
//

#import "UIScrollView+XSRefresh.h"
#import <MJRefresh.h>
#import "XSMJDIYHeader.h"

@interface UIScrollView ()

@property (nonatomic,copy)XSListRefreshBlock pullRefreshBlock;
@property (nonatomic,copy)XSListRefreshBlock loadMoreBlock;

@end

static NSString *permitOnlyOneRefreshKey = @"permitOnlyOneRefresh";
static NSString *pullRefreshBlockKey = @"pullRefreshBlockKey";
static NSString *loadMoreKey = @"loadMoreKey";

@implementation UIScrollView (XSRefresh)

#pragma mark -  Public
- (void)pullRefresh:(XSListRefreshBlock)block
{
    self.pullRefreshBlock = block;
    if(block)
    {
        if(self.mj_header)
        {
            return;
        }
        __weak __typeof(self) weakSelf = self;
        self.mj_header = [XSMJDIYHeader headerWithRefreshingBlock:^{
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
//        MJRefreshStateHeader *header = (MJRefreshStateHeader *)self.mj_header;
//        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header.ignoredScrollViewContentInsetTop = 0;
    }
    else
    {
        self.mj_header = nil;
    }
    
}
- (void)loadMore:(XSListRefreshBlock)block
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
        [autoFooter setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
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


#pragma mark ======  getter & setter  ======
- (BOOL)permitOnlyOneRefresh{
    NSNumber *refresh = objc_getAssociatedObject(self, &permitOnlyOneRefreshKey);
    return [refresh boolValue];
}

- (void)setPermitOnlyOneRefresh:(BOOL)permitOnlyOneRefresh{
    objc_setAssociatedObject(self, &permitOnlyOneRefreshKey, @(permitOnlyOneRefresh), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)openRefresh{
    NSNumber *openRefresh = objc_getAssociatedObject(self, &openRefresh);
    return [openRefresh boolValue];
}

- (void)setOpenRefresh:(BOOL)openRefresh{
    self.mj_header.hidden = !openRefresh;
    self.mj_footer.hidden = !openRefresh;
    objc_setAssociatedObject(self, &permitOnlyOneRefreshKey, @(openRefresh), OBJC_ASSOCIATION_ASSIGN);
}

- (XSListRefreshBlock)loadMoreBlock{
    return objc_getAssociatedObject(self, &loadMoreKey);
}

- (void)setLoadMoreBlock:(XSListRefreshBlock)loadMoreBlock{
    objc_setAssociatedObject(self, &loadMoreKey, loadMoreBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (XSListRefreshBlock)pullRefreshBlock{
    return objc_getAssociatedObject(self, &pullRefreshBlockKey);
}

- (void)setPullRefreshBlock:(XSListRefreshBlock)pullRefreshBlock{
    objc_setAssociatedObject(self, &pullRefreshBlockKey, pullRefreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
