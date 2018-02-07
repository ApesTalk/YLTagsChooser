//
//  YLTagsChooser.m
//  YLTagsChooser
//
//  Created by TK-001289 on 16/6/13.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLTagsChooser.h"
#import "NSArray+YLBoundsCheck.h"
#import "YLWaterFlowLayout.h"
#import "YLCollectionReusableView.h"
#import "YLTag.h"

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 屏幕尺寸
#define kFrameWidth [UIScreen mainScreen].bounds.size.width
#define kFrameHeight [UIScreen mainScreen].bounds.size.height

static NSString *headerIdentifier = @"YLCollectionReusableView";
static NSString *footerIdentifier = @"YLCollectionReusableView";
static NSString *cellIdentifier = @"YLTagsCollectionViewCell";

static NSTimeInterval const kSheetAnimationDuration = 0.25;
static CGFloat const kBottomBtnHeight = 44.f;
static CGFloat const kBottomGap = 24.f;
static CGFloat const kYGap = 10.f;

@interface YLTagsChooser()<UICollectionViewDataSource,UICollectionViewDelegate,YLWaterFlowLayoutDelegate>
{
    
}
@property (nonatomic,strong) UIView            *bottomView;
@property (nonatomic,strong) UICollectionView  *myCollectionView;
@property (nonatomic,strong) UIButton          *ensureBtn;
@property (nonatomic,strong) NSMutableArray    *orignalTags;
@property (nonatomic,strong) NSMutableArray    *selectedTags;

@end


@implementation YLTagsChooser
-(instancetype)initWithBottomHeight:(CGFloat)bHeight
                     maxSelectCount:(CGFloat)maxCount
                           delegate:(id<YLTagsChooserDelegate>)aDelegate
{
    if(self = [super initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)]){
        _orignalTags = [NSMutableArray array];
        _selectedTags = [NSMutableArray array];
        self.alpha = 0.f;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        self.bottomHeight = bHeight;
        self.maxSelectCount = maxCount;
        self.delegate = aDelegate;
        
        [self.bottomView addSubview:self.myCollectionView];
        [self.bottomView addSubview:self.ensureBtn];
        [self addSubview:self.bottomView];
    }
    return self;
}

-(void)refreshWithTags:(NSArray *)tags selectedTags:(NSArray *)selectedTags
{
    [_orignalTags removeAllObjects];
    [_orignalTags addObjectsFromArray:tags];
    
    [_selectedTags removeAllObjects];
    [_selectedTags addObjectsFromArray:selectedTags];
    
    for(NSArray *array in _orignalTags){
        for(YLTag *tag in array){
            tag.selected = [_selectedTags containsObject:tag];
        }
    }
    [self.myCollectionView reloadData];
}

-(UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _bottomView.frame = CGRectMake(0, kFrameHeight, kFrameWidth, _bottomHeight);
    }
    return _bottomView;
}

-(UICollectionView *)myCollectionView
{
    if(!_myCollectionView){
        YLWaterFlowLayout *layout = [[YLWaterFlowLayout alloc]init];
        layout.rowHeight = 30.f;
        layout.delegate = self;
        
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kYGap, kFrameWidth, _bottomHeight - 2 * kYGap - kBottomGap - kBottomBtnHeight)
                                              collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerClass:[YLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
        [_myCollectionView registerClass:[YLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
        [_myCollectionView registerClass:[YLTagsCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        //support set collectionview's contentInset
//        _myCollectionView.contentInset = UIEdgeInsetsMake(30, 20, 30, 20);
    }
    return _myCollectionView;
}

-(UIButton *)ensureBtn
{
    if(!_ensureBtn){
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureBtn.backgroundColor = HEXCOLOR(0x25c5b6);
        _ensureBtn.layer.cornerRadius = 5;
        _ensureBtn.layer.masksToBounds = YES;
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
        _ensureBtn.frame = CGRectMake(10, _bottomHeight - kBottomGap - kBottomBtnHeight, kFrameWidth - 20, kBottomBtnHeight);
    }
    return _ensureBtn;
}

#pragma mark---UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _orignalTags.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *sectionData = [_orignalTags yl_objectAtIndex:section];
    if([sectionData isKindOfClass:[NSArray class]]){
        return sectionData.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YLTagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                               forIndexPath:indexPath];
    NSArray *sectionData = [_orignalTags yl_objectAtIndex:indexPath.section];
    YLTag *tag = [sectionData yl_objectAtIndex:indexPath.row];
    [cell refreshWithObject:tag];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        YLCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        [header setTitle:[NSString stringWithFormat:@"Section Header %li",(long)indexPath.section]];
        return header;
    }else{
        YLCollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        [footer setTitle:[NSString stringWithFormat:@"Section Footer %li",(long)indexPath.section]];
        return footer;
    }
}

#pragma mark---YLWaterFlowLayoutDelegate
- (CGFloat)waterFlowLayout:(YLWaterFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionData = [_orignalTags yl_objectAtIndex:indexPath.section];
    YLTag *tag = [sectionData yl_objectAtIndex:indexPath.row];
    CGSize size = CGSizeMake(kFrameWidth - layout.sectionInset.left - layout.sectionInset.right,CGFLOAT_MAX);
    CGRect textRect = [tag.name
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                       context:nil];
    CGFloat width = textRect.size.width + 15;
    return width;
}

#pragma mark---UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionData = [_orignalTags yl_objectAtIndex:indexPath.section];
    YLTag *tag = [sectionData yl_objectAtIndex:indexPath.row];
    if(![_selectedTags containsObject:tag]){
        if(_selectedTags.count >= _maxSelectCount){
            //提示用户
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:[NSString stringWithFormat:@"最多选择%li个",(long)_maxSelectCount]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }else{
            tag.selected = YES;
            [_selectedTags addObject:tag];
        }
    }else{
        tag.selected = NO;
        [_selectedTags removeObject:tag];
    }
    
    [collectionView reloadData];
    //!!!!:Don't use this method! Should be optimized
//    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark---touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *lastTouch = [touches anyObject];
    CGPoint point = [lastTouch locationInView:self];
    if(!CGRectContainsPoint(self.bottomView.frame, point)){
        [self dismiss];
    }
}

#pragma mark---animation method
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    CGRect frame = self.bottomView.frame;
    frame.origin.y = kFrameHeight - _bottomHeight;
    [UIView animateWithDuration:kSheetAnimationDuration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bottomView.frame = frame;
                         self.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss
{
    CGRect frame = self.bottomView.frame;
    frame.origin.y = kFrameHeight;
    [UIView animateWithDuration:kSheetAnimationDuration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bottomView.frame = frame;
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}


#pragma mark---other methods
-(void)ensureAction
{
    if([_delegate respondsToSelector:@selector(tagsChooser:selectedTags:)]){
        [_delegate tagsChooser:self selectedTags:_selectedTags];
    }
    [self dismiss];
}

@end

#pragma mark---标签cell
@implementation YLTagsCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        _textLabel = [[UILabel alloc]init];
        //此处可以根据需要自己使用自动布局代码实现
        _textLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.layer.borderWidth = 1.f;
        _textLabel.layer.cornerRadius = frame.size.height * 0.5;
        _textLabel.layer.masksToBounds = YES;
        _textLabel.textColor = HEXCOLOR(0x666666);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)refreshWithObject:(NSObject *)obj
{
    if([obj isKindOfClass:[YLTag class]]){
        YLTag *tag = (YLTag *)obj;
        UIColor *borderColor = tag.selected ? HEXCOLOR(0xffb400) : HEXCOLOR(0xdddddd);
        UIColor *titleColor = tag.selected ? HEXCOLOR(0xffb400) : HEXCOLOR(0x666666);
        _textLabel.layer.borderColor = borderColor.CGColor;
        _textLabel.textColor = titleColor;
        _textLabel.text = tag.name;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    UIColor *borderColor = selected ? HEXCOLOR(0xffb400) : HEXCOLOR(0xdddddd);
    UIColor *titleColor = selected ? HEXCOLOR(0xffb400) : HEXCOLOR(0x666666);
    _textLabel.layer.borderColor = borderColor.CGColor;
    _textLabel.textColor = titleColor;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    UIColor *borderColor = highlighted ? HEXCOLOR(0xffb400) : HEXCOLOR(0xdddddd);
    UIColor *titleColor = highlighted ? HEXCOLOR(0xffb400) : HEXCOLOR(0x666666);
    _textLabel.layer.borderColor = borderColor.CGColor;
    _textLabel.textColor = titleColor;
}

@end
