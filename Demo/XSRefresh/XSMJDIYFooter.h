//
//  XSMJDIYFooter.h
//  XSSPH
//
//  Created by lijifeng on 2020/6/29.
//  Copyright © 2020 91sph. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSMJDIYFooter : MJRefreshAutoStateFooter

@property (weak, nonatomic, readonly) UIActivityIndicatorView *loadingView;

/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle MJRefreshDeprecated("first deprecated in 3.2.2 - Use `loadingView` property");

@end

NS_ASSUME_NONNULL_END
