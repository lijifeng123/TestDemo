//
//  IMXPaddingTableCell.m
//  IMXBaseCpt
//
//  Created by zhoupanpan on 2017/12/4.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXPaddingTableCell.h"

@interface IMXPaddingTableCell ()
@property (nonatomic,assign)CGFloat paddingHeight;
@end
@implementation IMXPaddingTableCell

- (void)dealloc{
}
#pragma mark ======  public  ======
- (void)loadWithPaddingHeight:(CGFloat)height{
    [self loadWithPaddingColor:[UIColor clearColor] height:height];
}
- (void)loadWithPaddingColor:(UIColor *)color height:(CGFloat)height{
    self.paddingHeight = height;
    self.backgroundColor = color;
    self.contentView.backgroundColor = color;
}
- (CGFloat)singleCellHeight{
    return self.paddingHeight;
}

#pragma mark ======  life cycle  ======
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark ======  delegate  ======

#pragma mark ======  event  ======

#pragma mark ======  private  ======

#pragma mark ======  getter & setter  ======


@end
