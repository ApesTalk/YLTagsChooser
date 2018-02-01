//
//  NSArray+YLBoundsCheck.m
//  YLLanJiQuan
//
//  Created by TK-001289 on 16/1/20.
//  Copyright (c) 2016年 YL. All rights reserved.
//

#import "NSArray+YLBoundsCheck.h"

@implementation NSArray (YLBoundsCheck)
- (id)yl_objectAtIndex:(NSUInteger)index
{
    if(index<self.count){
        return self[index];
    }else{
        return nil;
    }
}

@end
