//
//  IMXBaseCollectionViewCell.h
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMXBaseCollectionViewCell : UICollectionViewCell
+ (NSString *)IMXReuseID;
+ (CGFloat)cellHeight;

- (void)showTopLine:(UIEdgeInsets)insets;
- (void)hideTopLine;
- (void)showBottomLine:(UIEdgeInsets)insets;
- (void)hideBottomLine;
- (void)showLeftLine:(UIEdgeInsets)insets;
- (void)hideLeftLine;
- (void)showRightLine:(UIEdgeInsets)insets;
- (void)hideRightLine;

@end
