//
// UIScrollView+SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+SVPullToRefresh.h"

//fequal() and fequalzro() from http://stackoverflow.com/a/1614761/184130
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)
#define K_TITLE_OFFSET_Y 2

#define K_OFFSET_Y 60

static CGFloat const SVPullToRefreshViewHeight = 30 + K_OFFSET_Y;

@interface SVPullToRefreshArrow : UIView

@property (nonatomic, strong) UIColor *arrowColor;

@end


@interface SVPullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, copy) void (^pullToRefreshActionHandlerSuccessBlock)(void);

@property (nonatomic, strong) SVPullToRefreshArrow *arrow;
@property (nonatomic, strong) UIImageView *customArrow;
@property (nonatomic, strong) UIImageView *backGroundImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@property (nonatomic, readwrite) SVPullToRefreshState state;
@property (nonatomic, readwrite) SVPullToRefreshPosition position;
@property (nonatomic, strong, readwrite) UIView *cov;

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *subtitles;
@property (nonatomic, strong) NSMutableArray *viewForState;

@property (nonatomic, unsafe_unretained) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic,strong)UIImageView *finishImageV;

@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL showsDateLabel;
@property (nonatomic, assign) BOOL isObserving;
@property (nonatomic,assign)BOOL isHaveRefreshData;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;
- (void)rotateArrow:(float)degrees hide:(BOOL)hide;

@end



#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position {
    
    if(!self.pullToRefreshView) {
        CGFloat yOrigin;
        switch (position) {
            case SVPullToRefreshPositionTop:
                yOrigin = -SVPullToRefreshViewHeight;
                break;
            case SVPullToRefreshPositionBottom:
                yOrigin = self.contentSize.height;
                break;
            default:
                return;
        }
        SVPullToRefreshView *view = [[SVPullToRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight)];
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        view.position = position;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
    }
    
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler position:SVPullToRefreshPositionTop];
}

- (void)addPullToRefreshWithActionHandlerWithCustom:(void (^)(void))actionHandler {
    if(!self.pullToRefreshView) {
        CGFloat yOrigin;
        yOrigin = -SVPullToRefreshViewHeight;
        SVPullToRefreshView *view = [[SVPullToRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight)];
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        view.position = SVPullToRefreshPositionTop;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
        [view setHidden:YES];
        
//        view.animationV = [[[LCAnimationImageV alloc] initWithFrame:CGRectMake((self.width - 34)/2, -35, 34, 10) image:[UIImage imageNamed:@"animation_ball.png"]] autorelease];
//        [view.animationV animation:LCAnimationImageVAnimationTypeOff];
//        [self addSubview:view.animationV];
        
        UIImage *finishImage = [UIImage imageNamed:@"animaiton_finish.png"];
        view.finishImageV = [[[UIImageView alloc] init] autorelease];
        [view.finishImageV setFrame:CGRectMake((self.frame.size.width - 34)/2, -35, 22, 22)];
        [view.finishImageV setImage:finishImage];
        [self addSubview:view.finishImageV];
        [view.finishImageV setHidden:YES];
        finishImage = nil;
    }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler customImage:(UIImage *)image_ {
    if(!self.pullToRefreshView) {
        CGFloat yOrigin;
        yOrigin = -SVPullToRefreshViewHeight;
        SVPullToRefreshView *view = [[SVPullToRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight)];
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        view.position = SVPullToRefreshPositionTop;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
        
        double scale = 1.0;//下拉刷新用的是iphone6的图
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            scale = (double)640/750;
        }
        UIImage *backGroundImage = [UIImage imageNamed:@"Icon_Refresh.png"];//
        UIImageView *backGroundImageV = [[[UIImageView alloc] initWithImage:backGroundImage] autorelease];
        [backGroundImageV setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - backGroundImage.size.width/2)/2, -ceil(scale*backGroundImage.size.height/2) - 40 + K_TITLE_OFFSET_Y + 10, backGroundImage.size.width/2, ceil(scale*backGroundImage.size.height/2))];
        view.backGroundImageView = backGroundImageV;
        [self addSubview:backGroundImageV];
        backGroundImage = nil;
        
        UIImageView *customArrow = [[[UIImageView alloc] initWithImage:image_] autorelease];
        [customArrow setFrame:CGRectMake(120, -40 + K_TITLE_OFFSET_Y + 12, image_.size.width, image_.size.height)];
        view.customArrow = customArrow;
        [self addSubview:customArrow];
        customArrow = nil;
    }
}

- (void)triggerPullToRefresh {
    self.pullToRefreshView.state = SVPullToRefreshStateTriggered;
    [self.pullToRefreshView startAnimating];
}

- (void)setPullToRefreshView:(SVPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"SVPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SVPullToRefreshView"];
}

- (SVPullToRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    self.pullToRefreshView.customArrow.hidden = !showsPullToRefresh;
    self.pullToRefreshView.backGroundImageView.hidden = !showsPullToRefresh;
    if(!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
            
            CGFloat yOrigin = 0;
            switch (self.pullToRefreshView.position) {
                case SVPullToRefreshPositionTop:
                    yOrigin = -SVPullToRefreshViewHeight;
                    break;
                case SVPullToRefreshPositionBottom:
                    yOrigin = self.contentSize.height;
                    break;
            }
            
            self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
        }
    }
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}

@end

#pragma mark - SVPullToRefresh
@implementation SVPullToRefreshView

// public properties
@synthesize pullToRefreshActionHandler, arrowColor, textColor, activityIndicatorViewColor, activityIndicatorViewStyle, lastUpdatedDate, dateFormatter,pullToRefreshActionHandlerSuccessBlock;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;
@synthesize arrow = _arrow;
@synthesize customArrow = _customArrow;
@synthesize activityIndicatorView = _activityIndicatorView;

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;

+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.textColor = [SVPullToRefreshView colorWithHexString:@"9296a3"];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVPullToRefreshStateStopped;
        self.showsDateLabel = NO;
        
        self.titles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"下拉刷新...",),
                       NSLocalizedString(@"释放刷新...",),
                       NSLocalizedString(@"正在加载...",),
                       nil];

        self.subtitles = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
        self.viewForState = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", nil];
        self.wasTriggeredByUser = YES;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "SVPullToRefreshView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews {
    
    for(id otherView in self.viewForState) {
        if([otherView isKindOfClass:[UIView class]])
            [otherView removeFromSuperview];
    }
    
    id customView = [self.viewForState objectAtIndex:self.state];
    BOOL hasCustomView = [customView isKindOfClass:[UIView class]];
    
    self.titleLabel.hidden = hasCustomView;
    self.subtitleLabel.hidden = hasCustomView;
    self.arrow.hidden = hasCustomView;
    
    if(hasCustomView) {
        [self addSubview:customView];
        CGRect viewBounds = [customView bounds];
        CGPoint origin = CGPointMake(roundf((self.bounds.size.width-viewBounds.size.width)/2), roundf((self.bounds.size.height-viewBounds.size.height)/2));
        [customView setFrame:CGRectMake(origin.x, origin.y, viewBounds.size.width, viewBounds.size.height)];
    } else {
        switch (self.state) {
            case SVPullToRefreshStateAll:
            case SVPullToRefreshStateStopped:
                self.arrow.alpha = 1;
                [self.activityIndicatorView stopAnimating];
//                [self.animationV animation:LCAnimationImageVAnimationTypeOff];
                switch (self.position) {
                    case SVPullToRefreshPositionTop:{
                        [self rotateArrow:0 hide:NO];
                        break;
                    }
                    case SVPullToRefreshPositionBottom:
                        [self rotateArrow:(float)M_PI hide:NO];
                        break;
                }
                break;
                
            case SVPullToRefreshStateTriggered:
                switch (self.position) {
                    case SVPullToRefreshPositionTop:
                        [self rotateArrow:(float)M_PI hide:NO];
                        break;
                    case SVPullToRefreshPositionBottom:
                        [self rotateArrow:0 hide:NO];
                        break;
                }
                break;
                
            case SVPullToRefreshStateLoading:
                [self.activityIndicatorView startAnimating];
                switch (self.position) {
                    case SVPullToRefreshPositionTop:
                        [self rotateArrow:0 hide:YES];
//                        [self.animationV animation:LCAnimationImageVAnimationTypeOn];
                        break;
                    case SVPullToRefreshPositionBottom:
                        [self rotateArrow:(float)M_PI hide:YES];
                        break;
                }
                break;
        }
        
        CGFloat leftViewWidth = MAX(self.arrow.bounds.size.width,self.activityIndicatorView.bounds.size.width);
        
        CGFloat margin = 10;
        CGFloat marginY = 2;
        CGFloat labelMaxWidth = self.bounds.size.width - margin - leftViewWidth;
        
        self.titleLabel.text = [self.titles objectAtIndex:self.state];
        
        NSString *subtitle = [self.subtitles objectAtIndex:self.state];
        self.subtitleLabel.text = subtitle.length > 0 ? subtitle : nil;
        
        
        CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                            constrainedToSize:CGSizeMake(labelMaxWidth,self.titleLabel.font.lineHeight)
                                                lineBreakMode:self.titleLabel.lineBreakMode];
        
        
        CGSize subtitleSize = [self.subtitleLabel.text sizeWithFont:self.subtitleLabel.font
                                                  constrainedToSize:CGSizeMake(labelMaxWidth,self.subtitleLabel.font.lineHeight)
                                                      lineBreakMode:self.subtitleLabel.lineBreakMode];
        
        CGFloat maxLabelWidth = MAX(titleSize.width,subtitleSize.width);
        
        CGFloat totalMaxWidth;
        if (maxLabelWidth) {
            totalMaxWidth = leftViewWidth + margin + maxLabelWidth;
        } else {
            totalMaxWidth = leftViewWidth + maxLabelWidth;
        }
        
        CGFloat labelX = (self.bounds.size.width / 2) - (totalMaxWidth / 2) + leftViewWidth + margin;
        
        if(subtitleSize.height > 0){
            CGFloat totalHeight = titleSize.height + subtitleSize.height + marginY;
            CGFloat minY = (self.bounds.size.height / 2)  - (totalHeight / 2);
            
            CGFloat titleY = minY + K_OFFSET_Y/2;// + (self.customArrow ? K_TITLE_OFFSET_Y : 0);
            self.titleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY, titleSize.width, titleSize.height));
            self.subtitleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY + titleSize.height + marginY, subtitleSize.width, subtitleSize.height));
        }else{
            CGFloat totalHeight = titleSize.height;
            CGFloat minY = (self.bounds.size.height / 2)  - (totalHeight / 2);
            
            CGFloat titleY = minY + K_OFFSET_Y/2;// + (self.customArrow ? K_TITLE_OFFSET_Y : 0);
            self.titleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY, titleSize.width, titleSize.height));
            if (self.customArrow) {
                [self.customArrow setFrame:CGRectMake(self.titleLabel.frame.origin.x - self.customArrow.frame.size.width - 8, self.customArrow.frame.origin.y, self.customArrow.frame.size.width, self.customArrow.frame.size.height)];
            }
            self.subtitleLabel.frame = CGRectIntegral(CGRectMake(labelX, titleY + titleSize.height + marginY, subtitleSize.width, subtitleSize.height));
        }
        
        CGFloat arrowX = (self.bounds.size.width / 2) - (totalMaxWidth / 2) + (leftViewWidth - self.arrow.bounds.size.width) / 2;
        self.arrow.frame = CGRectMake(arrowX + 5,
                                      (self.bounds.size.height / 2) - (self.arrow.bounds.size.height / 2) + K_OFFSET_Y/2,
                                      self.arrow.bounds.size.width,
                                      self.arrow.bounds.size.height);
        self.activityIndicatorView.center = self.arrow.center;
//        self.activityIndicatorView.top += (self.customArrow ? K_TITLE_OFFSET_Y : 0);
    }
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            currentInsets.top = self.originalTopInset;
            break;
        case SVPullToRefreshPositionBottom:
            currentInsets.bottom = self.originalBottomInset;
            currentInsets.top = self.originalTopInset;
            break;
    }
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading {
//    self.scrollView.userInteractionEnabled = NO;//add by zhuhao at20131025
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
            break;
        case SVPullToRefreshPositionBottom:
            currentInsets.bottom = MIN(offset, self.originalBottomInset + self.bounds.size.height);
            break;
    }
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
//                         NSLog(@"contentInset = %f",contentInset.top);
//                         NSLog(@"self.scrollView.contentInset = %f",self.scrollView.contentInset.top);
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         if (contentInset.top == 0) {
                             [self.finishImageV setHidden:YES];
                         }
                     }];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        
        CGFloat yOrigin;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                yOrigin = -SVPullToRefreshViewHeight;
                break;
            case SVPullToRefreshPositionBottom:
                yOrigin = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
                break;
        }
        self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, SVPullToRefreshViewHeight);
    }
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];

}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != SVPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = 0;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                if (self.isHaveRefreshData) {
                    return;
                }
                scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;
                break;
            case SVPullToRefreshPositionBottom:
                scrollOffsetThreshold = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.bounds.size.height + self.originalBottomInset;
                break;
        }
        
        if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered)
            self.state = SVPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionTop)
            self.state = SVPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionTop)
            self.state = SVPullToRefreshStateStopped;
        else if(contentOffset.y > scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionBottom)
            self.state = SVPullToRefreshStateTriggered;
        else if(contentOffset.y <= scrollOffsetThreshold && self.state != SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionBottom)
            self.state = SVPullToRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
                contentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
                break;
            case SVPullToRefreshPositionBottom:
                if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                    offset = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.bounds.size.height, 0.0f);
                    offset = MIN(offset, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
                } else if (self.wasTriggeredByUser) {
                    offset = MIN(self.bounds.size.height, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(-offset, contentInset.left, contentInset.bottom, contentInset.right);
                }
                break;
        }
    }
}

#pragma mark - Getters

- (SVPullToRefreshArrow *)arrow {
    if(!_arrow) {
        _arrow = [[SVPullToRefreshArrow alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-54, 22, 48)];
        _arrow.backgroundColor = [UIColor clearColor];
        
        if (!self.customArrow) {
            [self addSubview:_arrow];
        }
    }
    return _arrow;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if(!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull to refresh...",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if(!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _subtitleLabel.font = [UIFont systemFontOfSize:12];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.textColor = textColor;
        [self addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (UILabel *)dateLabel {
    return self.showsDateLabel ? self.subtitleLabel : nil;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

- (UIColor *)arrowColor {
    return self.arrow.arrowColor; // pass through
}

- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

- (UIColor *)activityIndicatorViewColor {
    return self.activityIndicatorView.color;
}

- (UIActivityIndicatorViewStyle)activityIndicatorViewStyle {
    return self.activityIndicatorView.activityIndicatorViewStyle;
}

#pragma mark - Setters

- (void)setArrowColor:(UIColor *)newArrowColor {
    self.arrow.arrowColor = newArrowColor; // pass through
    [self.arrow setNeedsDisplay];
}

- (void)setTitle:(NSString *)title forState:(SVPullToRefreshState)state {
    if(!title)
        title = @"";
    
    if(state == SVPullToRefreshStateAll) {
        [self.titles replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[title, title, title]];
    } else {
        [self.titles replaceObjectAtIndex:state withObject:title];
    }
    [self setNeedsLayout];
}

- (void)setSubtitle:(NSString *)subtitle forState:(SVPullToRefreshState)state {
    if(!subtitle)
        subtitle = @"";
    
    if(state == SVPullToRefreshStateAll)
        [self.subtitles replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[subtitle, subtitle, subtitle]];
    else
        [self.subtitles replaceObjectAtIndex:state withObject:subtitle];
    
    [self setNeedsLayout];
}

- (void)setCustomView:(UIView *)view forState:(SVPullToRefreshState)state {
    id viewPlaceholder = view;
    
    if(!viewPlaceholder)
        viewPlaceholder = @"";
    
    if(state == SVPullToRefreshStateAll)
        [self.viewForState replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[viewPlaceholder, viewPlaceholder, viewPlaceholder]];
    else
        [self.viewForState replaceObjectAtIndex:state withObject:viewPlaceholder];
    
    [self setNeedsLayout];
}

- (void)setShadowView:(UIImage *)_shadowImage backGroundColor:(UIColor *)_color radius:(float)_radius; {
    UIView *backGroundV = [[UIView alloc] initWithFrame:CGRectMake(_radius, -400, self.frame.size.width - _radius*2, self.frame.size.height+400)];
    [backGroundV setBackgroundColor:_color];
    [self insertSubview:backGroundV atIndex:0];
    UIImageView *leftShadow = [[UIImageView alloc] initWithImage:_shadowImage];
    UIImageView *rightShadow = [[UIImageView alloc] initWithImage:_shadowImage];
    rightShadow.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    [leftShadow setFrame:CGRectMake(-_radius, 0, _radius, backGroundV.frame.size.height)];
    [rightShadow setFrame:CGRectMake(backGroundV.frame.size.width, 0, _radius, backGroundV.frame.size.height)];
    [backGroundV addSubview:leftShadow];
    [backGroundV addSubview:rightShadow];
    
    [backGroundV release] , backGroundV = nil;
    [leftShadow release] , leftShadow = nil;
    [rightShadow release] , rightShadow = nil;
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    self.titleLabel.textColor = newTextColor;
    self.subtitleLabel.textColor = newTextColor;
}

- (void)setActivityIndicatorViewColor:(UIColor *)color {
    self.activityIndicatorView.color = color;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.showsDateLabel = YES;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}

- (void)setDateFormatter:(NSDateFormatter *)newDateFormatter {
    dateFormatter = newDateFormatter;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Last Updated: %@",), self.lastUpdatedDate?[newDateFormatter stringFromDate:self.lastUpdatedDate]:NSLocalizedString(@"Never",)];
}

#pragma mark -

- (void)triggerRefresh {
    [self.scrollView triggerPullToRefresh];
}

- (void)startAnimating{
    //add by zhuhao at 20131012
    switch (self.position) {
        case SVPullToRefreshPositionTop:{
            if(fequalzero(self.scrollView.contentOffset.y)) {
//                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height)
//                                         animated:YES];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            //modify by zhuhao at 20131012
            if(!fequalzero(self.scrollView.contentOffset.y)) {
                [self.scrollView setContentOffset:CGPointZero animated:NO];
            }
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height)
                                         animated:NO];
            }completion:^(BOOL finished){
            
            }];
    }
                       break;
        case SVPullToRefreshPositionBottom:
            if((fequalzero(self.scrollView.contentOffset.y) && self.scrollView.contentSize.height < self.scrollView.bounds.size.height)
               || fequal(self.scrollView.contentOffset.y, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
                [self.scrollView setContentOffset:(CGPoint){.y = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.frame.size.height}
                                         animated:YES];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            
            break;
    }
    
    self.state = SVPullToRefreshStateLoading;
}

- (void)delayStop {
    self.pullToRefreshActionHandlerSuccessBlock();
    switch (self.position) {
        case SVPullToRefreshPositionTop:{
        }
            break;
        case SVPullToRefreshPositionBottom:
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.originalBottomInset) animated:YES];
            break;
    }
    self.pullToRefreshActionHandlerSuccessBlock = nil;
    self.isHaveRefreshData = NO;
}

- (void)stopAnimating:(SVPullToRefreshSuccess)_completion {
//    [self.animationV animation:LCAnimationImageVAnimationTypeOff];
    [self.finishImageV setHidden:NO];
    self.pullToRefreshActionHandlerSuccessBlock = _completion;
    self.state = SVPullToRefreshStateStopped;
    if (!self.isHaveRefreshData) {
        [self performSelector:@selector(delayStop) withObject:nil afterDelay:0.01];
    }
    self.isHaveRefreshData = YES;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateStopped;
    switch (self.position) {
        case SVPullToRefreshPositionTop:{
//            [self.animationV animation:LCAnimationImageVAnimationTypeOff];
        }
            break;
        case SVPullToRefreshPositionBottom:
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.originalBottomInset) animated:YES];
            break;
    }
//    double delayInSeconds = 1;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        self.scrollView.userInteractionEnabled = YES; //add by zhuhao at20131025
//    });
}

- (void)setState:(SVPullToRefreshState)newState {
    if(_state == newState)
        return;
    
    SVPullToRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    switch (newState) {
        case SVPullToRefreshStateAll:
        case SVPullToRefreshStateStopped:
            [self resetScrollViewContentInset];
            break;
            
        case SVPullToRefreshStateTriggered:
            break;
            
        case SVPullToRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            
            if(previousState == SVPullToRefreshStateTriggered && pullToRefreshActionHandler)
                pullToRefreshActionHandler();
            
            break;
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    if (self.customArrow) {
        if (hide) {
            [self.customArrow setHidden:YES];
        } else {
            [self.customArrow setHidden:NO];
        }
        self.customArrow.hidden = self.hidden;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.customArrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
            self.customArrow.layer.opacity = !hide;
            //[self.arrow setNeedsDisplay];//ios 4
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
            self.arrow.layer.opacity = !hide;
            //[self.arrow setNeedsDisplay];//ios 4
        } completion:NULL];
    }
}

@end


#pragma mark - SVPullToRefreshArrow

@implementation SVPullToRefreshArrow
@synthesize arrowColor;

- (UIColor *)arrowColor {
    if (arrowColor) return arrowColor;
    return [UIColor grayColor]; // default Color
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    // the rects above the arrow
    CGContextAddRect(c, CGRectMake(5, 0, 12, 4)); // to-do: use dynamic points
    CGContextAddRect(c, CGRectMake(5, 6, 12, 4)); // currently fixed size: 22 x 48pt
    CGContextAddRect(c, CGRectMake(5, 12, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 18, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 24, 12, 4));
    CGContextAddRect(c, CGRectMake(5, 30, 12, 4));
    
    // the arrow
    CGContextMoveToPoint(c, 0, 34);
    CGContextAddLineToPoint(c, 11, 48);
    CGContextAddLineToPoint(c, 22, 34);
    CGContextAddLineToPoint(c, 0, 34);
    CGContextClosePath(c);
    
    CGContextSaveGState(c);
    CGContextClip(c);
    
    // Gradient Declaration
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat alphaGradientLocations[] = {0, 0.8f};
    
    CGGradientRef alphaGradient = nil;
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 5){
        NSArray* alphaGradientColors = [NSArray arrayWithObjects:
                                        (id)[self.arrowColor colorWithAlphaComponent:0].CGColor,
                                        (id)[self.arrowColor colorWithAlphaComponent:1].CGColor,
                                        nil];
        alphaGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)alphaGradientColors, alphaGradientLocations);
    }else{
        const CGFloat * components = CGColorGetComponents([self.arrowColor CGColor]);
        size_t numComponents = CGColorGetNumberOfComponents([self.arrowColor CGColor]);
        CGFloat colors[8];
        switch(numComponents){
            case 2:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[0];
                colors[2] = colors[6] = components[0];
                break;
            }
            case 4:{
                colors[0] = colors[4] = components[0];
                colors[1] = colors[5] = components[1];
                colors[2] = colors[6] = components[2];
                break;
            }
        }
        colors[3] = 0;
        colors[7] = 1;
        alphaGradient = CGGradientCreateWithColorComponents(colorSpace,colors,alphaGradientLocations,2);
    }
    
    
    CGContextDrawLinearGradient(c, alphaGradient, CGPointZero, CGPointMake(0, rect.size.height), 0);
    
    CGContextRestoreGState(c);
    
    CGGradientRelease(alphaGradient);
    CGColorSpaceRelease(colorSpace);
}
@end
