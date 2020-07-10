//
//  UIScrollView+XSOldRefresh.m
//  XSSPH
//
//  Created by lijifeng on 2020/6/1.
//  Copyright © 2020 91sph. All rights reserved.
//
#import "UIScrollView+XSOldRefresh.h"
#import "UIScrollView+XSRefresh.h"
#import <Objc/runtime.h>

static NSString * const KPullToRefreshViewKey = @"KPullToRefreshViewKey";
static NSString * const KInfiniteScrollingView = @"KInfiniteScrollingView";
static NSString * const KShowsPullToRefresh = @"KShowsPullToRefresh";
static NSString * const KShowsInfiniteScrolling = @"KShowsInfiniteScrolling";

@implementation XSOldRefreshHeader

- (void)stopAnimating{
    if (self.stopAnimationBlock) {
        self.stopAnimationBlock();
    }
}

@end

@implementation XSOldRefreshFooter

- (void)stopAnimating{
    if (self.stopAnimationBlock) {
        self.stopAnimationBlock();
    }
}

@end

@implementation UIScrollView (XSOldRefresh)

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler customImage:(UIImage *)image_{
    [self pullRefresh:actionHandler];
    self.pullToRefreshView = [[XSOldRefreshHeader alloc] init];
    __weak typeof(self) weakSelf = self;
    self.pullToRefreshView.stopAnimationBlock = ^{
        [weakSelf openLoadMoreRefresh:YES];
        [weakSelf endPullRefresh];
    };
}

- (void)triggerPullToRefresh{
    [self beginPullRefresh];
}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler{
    [self loadMore:actionHandler];
    __weak typeof(self) weakSelf = self;
    self.infiniteScrollingView = [[XSOldRefreshFooter alloc] init];
    self.infiniteScrollingView.stopAnimationBlock = ^{
        [weakSelf endPullLoadmore];
    };
}

- (XSOldRefreshHeader *)pullToRefreshView{
    return objc_getAssociatedObject(self, &KPullToRefreshViewKey);
}

- (void)setPullToRefreshView:(XSOldRefreshHeader * _Nonnull)pullToRefreshView{
    objc_setAssociatedObject(self, &KPullToRefreshViewKey, pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XSOldRefreshFooter *)infiniteScrollingView{
    return objc_getAssociatedObject(self, &KInfiniteScrollingView);
}

- (void)setInfiniteScrollingView:(XSOldRefreshFooter * _Nonnull)infiniteScrollingView{
    objc_setAssociatedObject(self, &KInfiniteScrollingView, infiniteScrollingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showsPullToRefresh{
    return [objc_getAssociatedObject(self, &KShowsPullToRefresh) boolValue];
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh{
    [self openPullRefresh:showsPullToRefresh == YES ? YES : NO];
    objc_setAssociatedObject(self, &KShowsPullToRefresh, @(showsPullToRefresh), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)showsInfiniteScrolling{
    return [objc_getAssociatedObject(self, &KShowsInfiniteScrolling) boolValue];
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling{
    if (showsInfiniteScrolling) {
        [self resetNoMoreData];
    }else{
        [self noticeNoMoreData];
    }
    objc_setAssociatedObject(self, &KShowsInfiniteScrolling, @(showsInfiniteScrolling), OBJC_ASSOCIATION_ASSIGN);
}

@end
