//
//  YLTagsChooser.h
//  YLTagsChooser
//
//  Created by TK-001289 on 16/6/13.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLTagsChooserDelegate;

@interface YLTagsChooser : UIView
@property(nonatomic,weak)id<YLTagsChooserDelegate>delegate;
@property(nonatomic,assign) CGFloat    bottomHeight;   ///< 指定白色背景高度
@property(nonatomic,assign) NSInteger  maxSelectCount; ///< 最多可选择数量

/**
   必须调用的初始化方法
   you must call this init method
 */
-(instancetype)initWithBottomHeight:(CGFloat)bHeight
                    maxSelectCount:(CGFloat)maxCount
                           delegate:(id<YLTagsChooserDelegate>)aDelegate;

/**
 刷新

 @param tags 原数据。包含多个数组对象的数组，决定有几个section
 @param selectedTags 已选择的数据
 */
-(void)refreshWithTags:(NSArray *)tags selectedTags:(NSArray *)selectedTags;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end


//代理
@protocol YLTagsChooserDelegate <NSObject>

- (void)tagsChooser:(YLTagsChooser *)sheet selectedTags:(NSArray *)sTags;


@end

#pragma mark---标签cell
@interface YLTagsCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *textLabel;

- (void)refreshWithObject:(NSObject *)obj;

@end
