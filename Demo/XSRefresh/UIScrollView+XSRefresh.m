//
//  UIScrollView+XS_RefreshUIScrollView.m
//  Demo
//
//  Created by lijifeng on 2020/5/12.
//  Copyright © 2020 Musk Ronaldo Ming. All rights reserved.
//

#import "UIScrollView+XSRefresh.h"
#import "XSMJDIYHeader.h"
#import "XSMJDIYFooter.h"

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
                    if (strongself.pullRefreshBlock) {
                        strongself.pullRefreshBlock();
                    }
                }
            }else{
                [strongself resetNoMoreData];
                if (strongself.pullRefreshBlock) {
                    strongself.pullRefreshBlock();
                }
            }
        }];
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
        
        self.mj_footer = [XSMJDIYFooter footerWithRefreshingBlock:^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if(strongSelf.permitOnlyOneRefresh){
                if(self.mj_header && self.mj_header.refreshing){
                    [strongSelf endPullLoadmore];
                }else{
                    if (strongSelf.loadMoreBlock) {
                        strongSelf.loadMoreBlock();
                    }
                }
            }else{
                if (strongSelf.loadMoreBlock) {
                    strongSelf.loadMoreBlock();
                }
            }
        }];
        XSMJDIYFooter *autoFooter = (XSMJDIYFooter *)self.mj_footer;
        autoFooter.triggerAutomaticallyRefreshPercent = 1.0;
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
    [self noticeNoMoreData:@"没有更多了"];
}

- (void)noticeNoMoreData:(NSString *)noDataTip{
    if(self.loadMoreBlock)
    {
        XSMJDIYFooter *footer = (XSMJDIYFooter *)self.mj_footer;
        footer.hidden = noDataTip.length > 0 ? NO : YES;
        [footer setTitle:noDataTip forState:MJRefreshStateNoMoreData];
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)resetNoMoreData
{
    [self.mj_footer resetNoMoreData];
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
- (void)resetFooterWithContent:(NSString *)content state:(MJRefreshState)state
{
    XSMJDIYFooter *footer = (XSMJDIYFooter *)self.mj_footer;
    [footer setTitle:content forState:state];
}
- (void)refreshStatusWhenNextPageHasError:(NSError *)error
{
    [self endPullAllRefresh];
    
    if(self.loadMoreBlock)
    {
        //[self.mj_footer setTitle:@"加载失败,请重试～" forState:MJRefreshStateIdle];
    }
}


- (void)configXSTriggerAutomaticallyRefreshPercentkey:(CGFloat)percent{
    XSMJDIYFooter *autoFooter = (XSMJDIYFooter *)self.mj_footer;
    [autoFooter setTriggerAutomaticallyRefreshPercent:percent];
}

#pragma mark ======  getter & setter  ======
- (BOOL)permitOnlyOneRefresh{
    NSNumber *refresh = objc_getAssociatedObject(self, &permitOnlyOneRefreshKey);
    return [refresh boolValue];
}

- (void)setPermitOnlyOneRefresh:(BOOL)permitOnlyOneRefresh{
    objc_setAssociatedObject(self, &permitOnlyOneRefreshKey, @(permitOnlyOneRefresh), OBJC_ASSOCIATION_ASSIGN);
}

- (void)openPullRefresh:(BOOL)hideHeader{
    self.mj_header.hidden = !hideHeader;
}

- (void)openLoadMoreRefresh:(BOOL)hideFooter{
    self.mj_footer.hidden = !hideFooter;
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
