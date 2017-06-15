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

static NSString *sectionHeaderIdentifier = @"YLCollectionReusableView";
static NSString *cellIdentifier = @"YLTagsCollectionViewCell";

static NSTimeInterval const kSheetAnimationDuration = 0.25;
static CGFloat const kBottomBtnHeight = 44.f;
static CGFloat const kBottomGap = 24.f;
static CGFloat const kYGap = 10.f;

@interface YLTagsChooser()<UICollectionViewDelegate,UICollectionViewDataSource,YLWaterFlowLayoutDelegate>
{
    
}
@property (nonatomic,strong) UIView            *bottomView;
@property (nonatomic,strong) UICollectionView  *myCollectionView;
@property (nonatomic,strong) UIButton          *ensureBtn;
@property (nonatomic,copy  ) NSArray           *orignalTags;
@property (nonatomic,strong) NSMutableArray    *selectedTags;

@end


@implementation YLTagsChooser
-(instancetype)initWithBottomHeight:(CGFloat)bHeight
                     maxSelectCount:(CGFloat)maxCount
                           delegate:(id<YLTagsChooserDelegate>)aDelegate
{
    if(self = [super initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)]){
        _orignalTags = [NSArray array];
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
    self.orignalTags = tags;
    [_selectedTags removeAllObjects];
    [_selectedTags addObjectsFromArray:selectedTags];
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
        layout.rowHeight = 28.f;
        layout.delegate = self;
        
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kYGap, kFrameWidth, _bottomHeight - 2 * kYGap - kBottomGap - kBottomBtnHeight)
                                              collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerClass:[YLCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier];
        [_myCollectionView registerClass:[YLTagsCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _orignalTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YLTagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                               forIndexPath:indexPath];
    YLTag *tag = [_orignalTags yl_objectAtIndex:indexPath.row];
    [cell.btn setTitle:tag.name forState:UIControlStateNormal];
    cell.selected = [_selectedTags containsObject:tag];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    YLCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier forIndexPath:indexPath];
    return view;
}

#pragma mark---YLWaterFlowLayoutDelegate
- (CGFloat)waterFlowLayout:(YLWaterFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath
{
    YLTag *tag = [_orignalTags yl_objectAtIndex:indexPath.row];
    CGSize size = CGSizeMake(kFrameWidth - 20,CGFLOAT_MAX);
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
    YLTag *tag = [_orignalTags yl_objectAtIndex:indexPath.row];
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
            [_selectedTags addObject:tag];
        }
    }else{
        [_selectedTags removeObject:tag];
    }
    [collectionView reloadData];
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
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //此处可以根据需要自己使用自动布局代码实现
        _btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn.layer.borderWidth = 1.f;
        _btn.layer.cornerRadius = frame.size.height/2.0;
        _btn.layer.masksToBounds = YES;
        [_btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _btn.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
        _btn.userInteractionEnabled = NO;
        [self.contentView addSubview:_btn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _btn.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _btn.layer.borderColor = selected?HEXCOLOR(0xffb400).CGColor:HEXCOLOR(0xdddddd).CGColor;
    [_btn setTitleColor:selected?HEXCOLOR(0xffb400):HEXCOLOR(0x666666) forState:UIControlStateNormal];
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    _btn.layer.borderColor = highlighted?HEXCOLOR(0xffb400).CGColor:HEXCOLOR(0xdddddd).CGColor;
    [_btn setTitleColor:highlighted?HEXCOLOR(0xffb400):HEXCOLOR(0x666666) forState:UIControlStateNormal];
}

@end
