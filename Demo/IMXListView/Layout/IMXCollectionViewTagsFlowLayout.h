//
//  IMXCollectionViewTagsFlowLayout.h
//  IMXBaseModules
//
//  Created by zhoupanpan on 2017/9/7.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const IMXCollectionViewTagsFlowLayoutHeader;//header KEY
extern NSString *const IMXCollectionViewTagsFlowLayoutFooter;//footer KEY

@class IMXCollectionViewTagsFlowLayout;

@protocol IMXCollectionViewTagsDelegateLayout <UICollectionViewDelegate>

@required
//height需要固定
- (CGSize)collectionView:(UICollectionView *)collectionView customLayout:(IMXCollectionViewTagsFlowLayout *)layout sizeForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGSize)collectionView:(UICollectionView *)collectionView customLayout:(IMXCollectionViewTagsFlowLayout *)layout sizeForHeaderInSection:(NSInteger)section;

/*!
 @method collectionView:layout:heightForFooterInSection:
 @abstract 获取 section 底部控件的宽高
 @param collectionView collectionView
 @param layout layout
 @param section section
 */
- (CGSize)collectionView:(UICollectionView *)collectionView customLayout:(IMXCollectionViewTagsFlowLayout *)layout sizeForFooterInSection:(NSInteger)section;
@end


@interface IMXCollectionViewTagsFlowLayout : UICollectionViewLayout
//contentSize
@property(nonatomic, assign)CGSize contentSize;
/*!
 @property columnPadding
 @abstract 列之间的间距；默认为0
 */
@property (nonatomic, assign) CGFloat columnPadding;
/*!
 @property rowPadding
 @abstract 行之间的间距；默认为0
 */
@property (nonatomic, assign) CGFloat rowPadding;

/*!
 @property sectionInset
 @abstract section 内 四周边界的间距；默认为UIEdgeInsetsZero
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;

@property (nonatomic, weak) id<IMXCollectionViewTagsDelegateLayout> delegate;
@end
