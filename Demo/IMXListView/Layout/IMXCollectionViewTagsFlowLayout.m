//
//  IMXCollectionViewTagsFlowLayout.m
//  IMXBaseModules
//
//  Created by zhoupanpan on 2017/9/7.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "IMXCollectionViewTagsFlowLayout.h"

NSString *const IMXCollectionViewTagsFlowLayoutHeader = @"IMXCollectionViewTagsFlowLayoutHeader";
NSString *const IMXCollectionViewTagsFlowLayoutFooter = @"IMXCollectionViewTagsFlowLayoutFooter";

@interface  IMXCollectionViewTagsFlowLayout()
//上一个尾端右上角
@property(nonatomic,assign)CGPoint lastPoint;

//存放所有的布局属性
@property (nonatomic, strong) NSMutableArray *attributes;

@end
@implementation IMXCollectionViewTagsFlowLayout
- (void)dealloc
{
    _delegate = nil;
    self.attributes = nil;
}

#pragma mark ======  ivar  ======
- (void)setHeaderSize:(CGSize)headerSize
{
    if(!CGSizeEqualToSize(_headerSize, headerSize))
    {
        _headerSize = headerSize;
        
        [self invalidateLayout];
    }
}

- (void)setFooterSize:(CGSize)footerSize
{
    if(!CGSizeEqualToSize(_footerSize, footerSize))
    {
        _footerSize = footerSize;
        
        [self invalidateLayout];
    }
}

- (void)setColumnPadding:(CGFloat)columnPadding
{
    if (_columnPadding != columnPadding) {
        _columnPadding = columnPadding;
        [self invalidateLayout];
    }
}

- (void)setRowPadding:(CGFloat)rowPadding
{
    if (_rowPadding != rowPadding) {
        _rowPadding = rowPadding;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

#pragma mark ======  init  ======

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initialization];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        [self initialization];
    }
    return self;
}
- (void)initialization
{
    _columnPadding = .0f;
    _rowPadding = .0f;
    
    _sectionInset = UIEdgeInsetsZero;
    
    _headerSize = CGSizeZero;
    _footerSize = CGSizeZero;
    
    self.lastPoint = CGPointZero;
    self.attributes = [NSMutableArray array];
    _contentSize = CGSizeZero;
}

#pragma mark ======  life  ======

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.lastPoint = CGPointZero;
    [_attributes removeAllObjects];
    
    //header
    if (!CGSizeEqualToSize(_headerSize, CGSizeZero)) {
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:IMXCollectionViewTagsFlowLayoutHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        attribute.frame = CGRectMake(0, 0, _headerSize.width, _headerSize.height);
        [_attributes addObject:attribute];
        
        self.lastPoint = CGPointMake(0, _headerSize.height);
    }
    
    // item
    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger s = 0; s < sections; s++) {
        self.lastPoint = CGPointMake(0, _lastPoint.y + _sectionInset.top);
        //section header
        if (_delegate != nil && [_delegate conformsToProtocol:@protocol(IMXCollectionViewTagsDelegateLayout)] && [_delegate respondsToSelector:@selector(collectionView:customLayout:sizeForHeaderInSection:)]) {
            CGSize size = [_delegate collectionView:self.collectionView customLayout:self sizeForHeaderInSection:s];
            
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                
                UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:s]];
                attribute.frame = CGRectMake(0, _lastPoint.y, size.width, size.height);
                [_attributes addObject:attribute];
                
                self.lastPoint = CGPointMake(0, _lastPoint.y + size.height);
            }
        }
        
        // item
        NSInteger count = [self.collectionView numberOfItemsInSection:s];
        
        for (NSInteger i = 0; i < count; i++) {
            UICollectionViewLayoutAttributes *itemattribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:s]];
            [_attributes addObject:itemattribute];
            
            
            if(i==count-1)
            {
                self.lastPoint = CGPointMake(0, _lastPoint.y + itemattribute.size.height);
            }
        }
        
        self.lastPoint = CGPointMake(0, _lastPoint.y + _sectionInset.bottom);
        
        //section footer
        if (_delegate != nil && [_delegate conformsToProtocol:@protocol(IMXCollectionViewTagsDelegateLayout)] && [_delegate respondsToSelector:@selector(collectionView:customLayout:sizeForFooterInSection:)]) {
            CGSize size = [_delegate collectionView:self.collectionView customLayout:self sizeForFooterInSection:s];
            
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                
                
                UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:s]];
                attribute.frame = CGRectMake(0, _lastPoint.y, size.width, size.height);
                [_attributes addObject:attribute];
                self.lastPoint = CGPointMake(0, _lastPoint.y + size.height);
            }
        }
        
    }
    
    //footer
    if (!CGSizeEqualToSize(_footerSize, CGSizeZero)) {
        self.lastPoint = CGPointMake(0, _lastPoint.y + _sectionInset.bottom);
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:IMXCollectionViewTagsFlowLayoutFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        attribute.frame = CGRectMake(0, _lastPoint.y, _footerSize.width, _footerSize.height);
        [_attributes addObject:attribute];
        
        self.lastPoint = CGPointMake(0, _lastPoint.y + _footerSize.height);
        
        self.contentSize = CGSizeMake(self.collectionView.bounds.size.width, _lastPoint.y);
    }
    else {
        self.contentSize = CGSizeMake(self.collectionView.bounds.size.width, _lastPoint.y);
    }
}
- (CGSize)collectionViewContentSize
{
    return _contentSize;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *tmp_attributes = [NSMutableArray array];
    for(UICollectionViewLayoutAttributes *attributes in _attributes)
    {
        CGRect att_rect = attributes.frame;
        
        if(CGRectIntersectsRect(rect, att_rect))
        {
            [tmp_attributes addObject:attributes];
        }
    }
    return tmp_attributes;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}
//单一attribute
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(IMXCollectionViewTagsDelegateLayout)] && [_delegate respondsToSelector:@selector(collectionView:customLayout:sizeForRowAtIndexPath:)]) {
        size = [_delegate collectionView:self.collectionView customLayout:self sizeForRowAtIndexPath:indexPath];
    }
    if(indexPath.item == 0)
    {
        _lastPoint = CGPointMake(_sectionInset.left, _lastPoint.y);
    }
    else
    {
        _lastPoint = CGPointMake(_lastPoint.x+_columnPadding, _lastPoint.y);
    }
    
    if((_lastPoint.x+size.width + _sectionInset.right)>self.collectionView.bounds.size.width)
    {
        _lastPoint = CGPointMake(_sectionInset.left, _lastPoint.y+_rowPadding+size.height);
    }
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attribute.frame = CGRectMake(_lastPoint.x, _lastPoint.y, size.width, size.height);
    
    _lastPoint = CGPointMake(_lastPoint.x+size.width, _lastPoint.y);
    
    return attribute;
}

@end
