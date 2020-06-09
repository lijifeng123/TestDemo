//
//  IMXTextShowTableReuseView.h
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/20.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <IMXBaseCpt/IMXBaseCpt.h>


/**
 文本展示，并高度大小可变
 */
@interface IMXTextShowTableReuseView : IMXUITableReuseView
@property (nonatomic,assign)UIEdgeInsets insets;
@property (nonatomic,strong)UIColor *imx_backgroudColor;
- (void)loadCell:(NSAttributedString *)astring;
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width;
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width insets:(UIEdgeInsets)insets;
@end
