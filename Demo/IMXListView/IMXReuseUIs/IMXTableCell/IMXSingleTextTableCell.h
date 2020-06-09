//
//  IMXSingleTextTableCell.h
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/7.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <IMXBaseCpt/IMXBaseCpt.h>

@interface IMXSingleTextTableCell : IMXBaseTableViewCell
@property (nonatomic,strong)UIColor *backColor;

- (void)loadCell:(NSAttributedString *)astring;
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width;
+ (CGFloat)cellHeight:(NSAttributedString *)astring fixWidth:(CGFloat)width insets:(UIEdgeInsets)insets;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier insets:(UIEdgeInsets)insets;
@end
