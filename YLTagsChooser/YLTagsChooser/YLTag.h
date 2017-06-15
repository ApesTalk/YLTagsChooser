//
//  YLTag.h
//  YLTagsChooser
//
//  Created by TK-001289 on 2017/6/15.
//  Copyright © 2017年 YL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLTag : NSObject
@property(nonatomic,assign)NSInteger objId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)BOOL selected;///< default is NO

- (instancetype)initWithId:(NSInteger)oId name:(NSString *)name;

@end
