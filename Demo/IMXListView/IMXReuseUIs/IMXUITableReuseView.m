//
//  IMXUITableReuseView.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXUITableReuseView.h"

@implementation IMXUITableReuseView

- (void)dealloc{
}
#pragma mark ======  public  ======
+ (NSString *)IMXReuseID{
    return NSStringFromClass([self class]);
}
+ (CGFloat)cellHeight{
    return 0;
}
#pragma mark ======  life cycle  ======

#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======

#pragma mark ======  getter & setter  ======



@end
