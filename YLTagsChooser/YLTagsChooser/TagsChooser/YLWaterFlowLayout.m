//
//  YLWaterFlowLayout.m
//  YLLanJiQuan
//
//  Created by TK-001289 on 16/5/10.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLWaterFlowLayout.h"
#import "NSArray+YLBoundsCheck.h"
#import <UIKit/UICollectionViewCell.h>

@interface YLWaterFlowLayout()
@property(nonatomic,strong)NSMutableArray *framesArray;
@property(nonatomic,assign)CGFloat contentHeight;
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
    //support set sectionheader and sectionfooter at the same time
    self.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 50);//设置section header 固定高度，如果需要的话
    self.footerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 30);//设置section footer 固定高度，如果需要的话
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
//step1
- (void)prepareLayout {
    [super prepareLayout];
    [self calculateFrames];
}

#pragma mark - CollectionView的滚动范围
//step2
- (CGSize)collectionViewContentSize
{
    //support set collectionview's contentInset
    CGFloat width = self.collectionView.frame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    return CGSizeMake(width, _contentHeight);
}

#pragma mark - 当尺寸有所变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - 所有cell和view的布局属性
//sectionheader sectionfooter decorationview collectionviewcell的属性都会走这个方法
//step3
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [NSMutableArray array];
    CGPoint offset = self.collectionView.contentOffset;
    CGRect visibleRect = CGRectMake(0, offset.y, CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    for(NSInteger section = 0; section < _framesArray.count; section++){
        CGFloat currentSectionHeight = [self contentHeightInSection:section];
        CGFloat preSectionHeight = 0;
        if(section > 0){
            preSectionHeight = [self contentHeightInSection:section - 1];
        }
        
        NSArray *currentSectionFrames = _framesArray[section];
        if(currentSectionFrames.count == 0){
            //section header should show
            CGFloat y = section == 0 ? self.collectionView.contentInset.top : preSectionHeight;
            [attributesArray addObject:[self headerAttri:[NSIndexPath indexPathForRow:0 inSection:section] withY:y]];

            //current section footer should show
            NSIndexPath *footerIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            y = currentSectionHeight - self.footerReferenceSize.height;
            [attributesArray addObject:[self footerAttri:footerIndexPath withY:y]];
            
            if(section > 0 && section + 1 < _framesArray.count &&
               y + self.footerReferenceSize.height <= visibleRect.origin.y + visibleRect.size.height){
                //next section header should show
                [attributesArray addObject:[self headerAttri:[NSIndexPath indexPathForRow:0 inSection:section + 1] withY:y + self.footerReferenceSize.height]];
            }
        }else{
            for(NSInteger row = 0; row < currentSectionFrames.count; row++){
                CGRect currentFrame = [currentSectionFrames[row] CGRectValue];
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
                if(currentFrame.origin.y + currentFrame.size.height >= visibleRect.origin.y &&
                   currentFrame.origin.y <= visibleRect.origin.y + visibleRect.size.height){
                    //when first row appear
                    if(row == 0){
                        //section header should show
                        CGFloat y = section == 0 ? self.collectionView.contentInset.top : preSectionHeight;
                        [attributesArray addObject:[self headerAttri:currentIndexPath withY:y]];
                        
                        if(section > 0){
                            //pre section's footer should show
                            NSInteger preSection = section - 1;
                            NSArray *preSectionFrames = _framesArray[preSection];
                            NSIndexPath *footerIndexPath = [NSIndexPath indexPathForRow:preSectionFrames.count inSection:preSection];
                            CGFloat y = preSectionHeight - self.footerReferenceSize.height;
                            [attributesArray addObject:[self footerAttri:footerIndexPath withY:y]];
                        }
                    }
                    
                    //cells should show
                    UICollectionViewLayoutAttributes *cellAttrs = [[self layoutAttributesForItemAtIndexPath:currentIndexPath] copy];
                    cellAttrs.frame = currentFrame;
                    [attributesArray addObject:cellAttrs];
                    
                    //when last cell appear
                    if(row == currentSectionFrames.count - 1 &&
                       currentFrame.origin.y + currentFrame.size.height + self.sectionInset.bottom <= visibleRect.origin.y + visibleRect.size.height){
                        //current section footer should show
                        NSIndexPath *footerIndexPath = [NSIndexPath indexPathForRow:currentSectionFrames.count inSection:section];
                        CGFloat y = currentSectionHeight - self.footerReferenceSize.height;
                        [attributesArray addObject:[self footerAttri:footerIndexPath withY:y]];
                        
                        //next section header should show
                        NSInteger nextSection = section + 1;
                        if(nextSection < _framesArray.count){
                            NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:nextSection];
                            [attributesArray addObject:[self headerAttri:headerIndexPath withY:currentSectionHeight]];
                        }
                    }
                }
            }
        }
    }
    return attributesArray;
}

#pragma mark---other methods
- (UICollectionViewLayoutAttributes *)headerAttri:(NSIndexPath *)indexPath withY:(CGFloat)y
{
    UICollectionViewLayoutAttributes *headerAttr = [[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                         atIndexPath:indexPath] copy];
    CGRect frame = headerAttr.frame;
    frame.origin.y = y;
    headerAttr.frame = frame;
    return headerAttr;
}

- (UICollectionViewLayoutAttributes *)footerAttri:(NSIndexPath *)indexPath withY:(CGFloat)y
{
    UICollectionViewLayoutAttributes *footerAttr = [[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                         atIndexPath:indexPath] copy];
    CGRect frame = footerAttr.frame;
    frame.origin.y = y;
    footerAttr.frame = frame;
    return footerAttr;
}

- (void)calculateFrames
{
    if(_framesArray.count > 0){
//        return;
        [_framesArray removeAllObjects];
    }
    
    NSInteger sectionCount = self.collectionView.numberOfSections;
    for(NSInteger section = 0; section < sectionCount; section++){
        CGFloat preSectionHeight = 0;
        if(section > 0){
            preSectionHeight = [self contentHeightInSection:section - 1];
        }
        
        NSMutableArray *currentSectionFrames = [NSMutableArray arrayWithCapacity:sectionCount];
        [_framesArray addObject:currentSectionFrames];
        
        NSInteger numberOfRows = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger row = 0; row < numberOfRows; row++){
            CGFloat x = self.sectionInset.left;
            //如果有sectionheader需要加上sectionheader高度
            CGFloat y = self.headerReferenceSize.height + self.sectionInset.top + self.collectionView.contentInset.top;
            
            if(section > 0 && _framesArray.count > section - 1){
                y = preSectionHeight + self.headerReferenceSize.height + self.sectionInset.top;
            }
            //判断获得前一个cell的frame
            NSInteger preRow = row - 1;
            if(preRow >= 0 && currentSectionFrames.count > preRow){
                CGRect preCellFrame = [currentSectionFrames[preRow] CGRectValue];
                x = preCellFrame.origin.x + preCellFrame.size.width + self.minimumInteritemSpacing;
                y = preCellFrame.origin.y;
            }
            
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            CGFloat currentWidth = [self.delegate waterFlowLayout:self widthAtIndexPath:currentIndexPath];
            //保证一个cell不超过最大宽度
            CGFloat maxCellWidth = self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
            currentWidth = MIN(currentWidth, maxCellWidth);
            if(x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right - self.collectionView.contentInset.right){
                //超出范围，换行
                x = self.sectionInset.left;
                y += _rowHeight + self.minimumLineSpacing;
            }
            // 创建属性
            CGRect currentCellFrame = CGRectMake(x, y, currentWidth, _rowHeight);
            [currentSectionFrames addObject:[NSValue valueWithCGRect:currentCellFrame]];
        }
    }
    _contentHeight = [self contentHeightInSection:_framesArray.count - 1] + self.collectionView.contentInset.bottom;
}

- (CGFloat)contentHeightInSection:(NSInteger)section
{
    __block CGFloat height = 0;
    if(section >= 0 && _framesArray.count > section){
        NSArray *sectionYArray = [_framesArray yl_objectAtIndex:section];
        if(sectionYArray.count == 0){
            height = self.headerReferenceSize.height + self.sectionInset.top + self.sectionInset.bottom + self.footerReferenceSize.height;
            if(section == 0){
                height += self.collectionView.contentInset.top;
            }else{
                height += [self contentHeightInSection:section - 1];
            }
        }else{
            [sectionYArray enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect frame = [value CGRectValue];
                CGFloat y = frame.origin.y;
                if (y > height) {
                    height = y;
                }
            }];
            height += _rowHeight + self.sectionInset.bottom + self.footerReferenceSize.height;
        }
    }
    return height;
}

@end
