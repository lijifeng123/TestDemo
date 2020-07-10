//
//  UIScrollView+XSOldRefresh.h
//  XSSPH
//
//  Created by lijifeng on 2020/6/1.
//  Copyright © 2020 91sph. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^StopAnimationBlock)(void);

@interface XSOldRefreshHeader : UIScrollView

@property (nonatomic, copy) StopAnimationBlock stopAnimationBlock;

- (void)stopAnimating;

@end

@interface XSOldRefreshFooter : UIScrollView

@property (nonatomic, copy) StopAnimationBlock stopAnimationBlock;

- (void)stopAnimating;

@end

@interface UIScrollView (XSOldRefresh)

@property (nonatomic, strong) XSOldRefreshHeader *pullToRefreshView;
@property (nonatomic, strong) XSOldRefreshFooter *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler customImage:(UIImage *)image_;
- (void)triggerPullToRefresh;


@end

NS_ASSUME_NONNULL_END
