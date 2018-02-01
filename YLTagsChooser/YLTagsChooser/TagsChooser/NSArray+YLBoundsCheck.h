//
//  NSArray+YLBoundsCheck.h
//  YLLanJiQuan
//
//  Created by TK-001289 on 16/1/20.
//  Copyright (c) 2016年 YL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YLBoundsCheck)

/**对数组边界进行检查，避免数组越界*/
- (id)yl_objectAtIndex:(NSUInteger)index;

@end
