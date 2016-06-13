//
//  YLWaterFlowLayout.m
//  YLLanJiQuan
//
//  Created by TK-001289 on 16/5/10.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLWaterFlowLayout.h"

@interface YLWaterFlowLayout()
@property(nonatomic,strong)NSMutableArray *originxArray;
@property(nonatomic,strong)NSMutableArray *originyArray;
@end


@implementation YLWaterFlowLayout
#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 5;//同一行不同cell间距
        self.minimumLineSpacing = 5;//行间距
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        _originxArray = [NSMutableArray array];
        _originyArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
#pragma mark - 当尺寸有所变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark - 处理所有的Item的layoutAttributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:array.count];
    for(UICollectionViewLayoutAttributes *attrs in array){
        UICollectionViewLayoutAttributes *theAttrs = [self layoutAttributesForItemAtIndexPath:attrs.indexPath];
        [mutArray addObject:theAttrs];
    }
    return mutArray;
}

#pragma mark - 处理单个的Item的layoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat x = self.sectionInset.left;
    CGFloat y = self.sectionInset.top;
    //判断获得前一个cell的x和y
    NSInteger preRow = indexPath.row - 1;
    if(preRow >= 0){
        if(_originyArray.count > preRow){
            x = [_originxArray[preRow]floatValue];
            y = [_originyArray[preRow]floatValue];
        }
        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:preRow inSection:indexPath.section];
        CGFloat preWidth = [self.delegate waterFlowLayout:self widthAtIndexPath:preIndexPath];
        x += preWidth + self.minimumInteritemSpacing;
    }
    
    CGFloat currentWidth = [self.delegate waterFlowLayout:self widthAtIndexPath:indexPath];
    //保证一个cell不超过最大宽度
    currentWidth = MIN(currentWidth, self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right);
    if(x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right){
        //超出范围，换行
        x = self.sectionInset.left;
        y += _rowHeight + self.minimumLineSpacing;
    }
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, currentWidth, _rowHeight);
    _originxArray[indexPath.row] = @(x);
    _originyArray[indexPath.row] = @(y);
    return attrs;
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.frame.size.width;
    
    __block CGFloat maxY = 0;
    [_originyArray enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([number floatValue] > maxY) {
            maxY = [number floatValue];
        }
    }];

    return CGSizeMake(width, maxY + _rowHeight + self.sectionInset.bottom);
}

@end
