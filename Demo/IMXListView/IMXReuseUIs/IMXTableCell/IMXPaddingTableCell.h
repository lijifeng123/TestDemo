//
//  IMXPaddingTableCell.h
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <IMXBaseCpt/IMXBaseCpt.h>

@interface IMXPaddingTableCell : IMXBaseTableViewCell
- (void)loadWithPaddingHeight:(CGFloat)height;
- (void)loadWithPaddingColor:(UIColor *)color height:(CGFloat)height;
@end
