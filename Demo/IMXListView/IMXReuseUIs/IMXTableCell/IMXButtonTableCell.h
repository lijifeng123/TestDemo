//
//  IMXButtonTableCell.h
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <IMXBaseCpt/IMXBaseCpt.h>

@interface IMXButtonTableCell : IMXBaseTableViewCell
@property(nonatomic, copy)   NSString *btnTitle;
@property(nonatomic, copy)   dispatch_block_t buttonBlock;
- (instancetype)initWithInset:(UIEdgeInsets)inset cellStyle:(UITableViewCellStyle)style btn:(id)btn reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateCell;
- (void)enableBtn:(BOOL)enable;
@end
