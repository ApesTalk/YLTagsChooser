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
    self.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 50);//设置section header 固定高度，如果需要的话
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
    CGFloat width = self.collectionView.frame.size.width;
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
        NSArray *currentSectionFrames = _framesArray[section];
        for(NSInteger row = 0; row < currentSectionFrames.count; row++){
            CGRect currentFrame = [currentSectionFrames[row] CGRectValue];
            NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            if(currentFrame.origin.y + currentFrame.size.height >= visibleRect.origin.y &&
               currentFrame.origin.y <= visibleRect.origin.y + visibleRect.size.height){
                //first section header should show
                if(row == 0 && section == 0){
                    UICollectionViewLayoutAttributes *headerAttr = [[self layoutAttributesForSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader"
                                                                                                         atIndexPath:currentIndexPath] copy];
                    CGRect frame = headerAttr.frame;
                    frame.origin.y = 0;
                    headerAttr.frame = frame;
                    [attributesArray addObject:headerAttr];
                }
                
                //cell should show
                UICollectionViewLayoutAttributes *cellAttrs = [[self layoutAttributesForItemAtIndexPath:currentIndexPath] copy];
                cellAttrs.frame = currentFrame;
                [attributesArray addObject:cellAttrs];
                
                //next section header should show
                if(row == currentSectionFrames.count - 1 && section + 1 < _framesArray.count &&
                   currentFrame.origin.y + currentFrame.size.height + self.sectionInset.bottom < visibleRect.origin.y + visibleRect.size.height){
                    UICollectionViewLayoutAttributes *headerAttr = [[self layoutAttributesForSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader"
                                                                                                         atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section + 1]] copy];
                    CGFloat y = [self contentHeightInSection:section];
                    CGRect frame = headerAttr.frame;
                    frame.origin.y = y;
                    headerAttr.frame = frame;
                    [attributesArray addObject:headerAttr];
                }
            }
        }
    }
    return attributesArray;
}

#pragma mark---other methods
- (void)calculateFrames
{
    if(_framesArray.count > 0){
        return;
    }
    NSInteger sectionCount = self.collectionView.numberOfSections;
    for(NSInteger section = 0; section < sectionCount; section++){
        NSMutableArray *currentSectionFrames = [NSMutableArray arrayWithCapacity:sectionCount];
        [_framesArray addObject:currentSectionFrames];
        
        NSInteger numberOfRows = [self.collectionView numberOfItemsInSection:section];
        for(NSInteger row = 0; row < numberOfRows; row++){
            CGFloat x = self.sectionInset.left;
            //如果有sectionheader需要加上sectionheader高度
            CGFloat y = self.headerReferenceSize.height + self.sectionInset.top;
            
            if(section > 0 && _framesArray.count > section - 1){
                y = [self contentHeightInSection:section - 1] + self.headerReferenceSize.height + self.sectionInset.top;
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
            currentWidth = MIN(currentWidth, self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right);
            if(x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right){
                //超出范围，换行
                x = self.sectionInset.left;
                y += _rowHeight + self.minimumLineSpacing;
            }
            // 创建属性
            CGRect currentCellFrame = CGRectMake(x, y, currentWidth, _rowHeight);
            [currentSectionFrames addObject:[NSValue valueWithCGRect:currentCellFrame]];
        }
    }
    _contentHeight = [self contentHeightInSection:_framesArray.count - 1];
}

- (CGFloat)contentHeightInSection:(NSInteger)section
{
    __block CGFloat height = 0;
    if(section >= 0 && _framesArray.count > section){
        NSArray *sectionYArray = [_framesArray yl_objectAtIndex:section];
        [sectionYArray enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = [value CGRectValue];
            CGFloat y = frame.origin.y;
            if (y > height) {
                height = y;
            }
        }];
        height += _rowHeight + self.sectionInset.bottom;
    }
    return height;
}

@end
