//
//  YLTag.m
//  YLTagsChooser
//
//  Created by TK-001289 on 2017/6/15.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "YLTag.h"

@implementation YLTag
- (instancetype)initWithId:(NSInteger)oId name:(NSString *)name
{
    if(self = [super init]){
        self.objId = oId;
        self.name = name;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if(!object || ![object isKindOfClass:[self class]]){
        return NO;
    }
    YLTag *otherTag = (YLTag *)object;
    return self.objId == otherTag.objId && [self.name isEqualToString:otherTag.name];
}

- (NSString *)description
{
    return self.name;
}

@end
