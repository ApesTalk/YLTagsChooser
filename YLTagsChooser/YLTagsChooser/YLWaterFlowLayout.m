//
//  YLWaterFlowLayout.m
//  YLLanJiQuan
//
//  Created by TK-001289 on 16/5/10.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLWaterFlowLayout.h"
#import "NSArray+YLBoundsCheck.h"

@interface YLWaterFlowLayout()
@property(nonatomic,strong)NSMutableArray *framesArray;
@end


@implementation YLWaterFlowLayout
#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLayout];
        _framesArray = [NSMutableArray array];
    }
    return self;
}

- (void)setupLayout
{
    self.minimumInteritemSpacing = 10;//同一行不同cell间距
    self.minimumLineSpacing = 10;//行间距
    self.headerReferenceSize = CGSizeMake(0, 50);//设置section header 固定高度，如果需要的话
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
#pragma mark - 当尺寸有所变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark - 所有cell和view的布局属性
//sectionheader sectionfooter decorationview collectionviewcell的属性都会走这个方法
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *tmpArray = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:tmpArray.count];
    for(NSInteger i = 0; i < tmpArray.count; i++){
        UICollectionViewLayoutAttributes *attrs = [tmpArray objectAtIndex:i];
        UICollectionElementCategory category = attrs.representedElementCategory;
        if(category == UICollectionElementCategoryCell){
            [array addObject:[self layoutAttributesForItemAtIndexPath:attrs.indexPath]];
        }else if (category == UICollectionElementCategorySupplementaryView){
            UICollectionViewLayoutAttributes *theAttrs = [self layoutAttributesForSupplementaryViewOfKind:attrs.representedElementKind atIndexPath:attrs.indexPath];
            [array addObject:theAttrs];
        }
    }
    return array;
}

#pragma mark - 指定cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [[super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath] copy];
    NSInteger section = attrs.indexPath.section;
    if(section > 0 && _framesArray.count > section - 1){
        CGFloat y = [self maxOrignYInSection:section - 1] + _rowHeight + self.sectionInset.bottom;
        CGRect frame = attrs.frame;
        frame.origin.y = y;
        attrs.frame = frame;
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UICollectionViewLayoutAttributes *attrs = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    //已经计算过了
    if(_framesArray.count > section){
        NSArray *sectionFramesArray = _framesArray[section];
        if(sectionFramesArray.count > row){
            attrs.frame = [sectionFramesArray[row] CGRectValue];
            return attrs;
        }
    }
    
    //计算新的
    CGFloat x = self.sectionInset.left;
    //如果有sectionheader需要加上sectionheader高度
    CGFloat y = self.headerReferenceSize.height + self.sectionInset.top;
    
    if(section > 0 && _framesArray.count > section - 1){
        y = [self maxOrignYInSection:section - 1] + _rowHeight + self.sectionInset.bottom + self.headerReferenceSize.height + self.sectionInset.top;
    }
    
    NSMutableArray *sectionFramesArray = [_framesArray yl_objectAtIndex:section];
    if(!sectionFramesArray){
        sectionFramesArray = [NSMutableArray array];
        _framesArray[section] = sectionFramesArray;
    }
    
    //判断获得前一个cell的frame
    NSInteger preRow = row - 1;
    if(preRow >= 0 && sectionFramesArray.count > preRow){
        CGRect preCellFrame = [sectionFramesArray[preRow] CGRectValue];
        x = preCellFrame.origin.x + preCellFrame.size.width + self.minimumInteritemSpacing;
        y = preCellFrame.origin.y;
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
    CGRect currentCellFrame = CGRectMake(x, y, currentWidth, _rowHeight);
    attrs.frame = currentCellFrame;
    sectionFramesArray[row] = [NSValue valueWithCGRect:currentCellFrame];
    return attrs;
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat maxY = [self maxOrignYInSection:_framesArray.count - 1];
    return CGSizeMake(width, maxY + _rowHeight + self.sectionInset.bottom);
}

#pragma mark---other methods
- (CGFloat)maxOrignYInSection:(NSInteger)section
{
    __block CGFloat maxY = 0;
    if(section >= 0 && _framesArray.count > section){
        NSArray *sectionYArray = [_framesArray yl_objectAtIndex:section];
        [sectionYArray enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = [value CGRectValue];
            CGFloat y = frame.origin.y;
            if (y > maxY) {
                maxY = y;
            }
        }];
    }
    return maxY;
}

@end
