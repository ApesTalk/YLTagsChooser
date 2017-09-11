//
//  YLWaterFlowLayout.h
//  YLLanJiQuan
//
//  Created by TK-001289 on 16/5/10.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YLWaterFlowLayout_Bug;
@protocol  YLWaterFlowLayoutDelegate <NSObject>
/**通过代理获得每个cell的宽度*/
- (CGFloat)waterFlowLayout:(YLWaterFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YLWaterFlowLayout_Bug : UICollectionViewFlowLayout
@property (nonatomic,assign) id<YLWaterFlowLayoutDelegate> delegate;
@property(nonatomic,assign)CGFloat rowHeight;///< 固定行高

@end

