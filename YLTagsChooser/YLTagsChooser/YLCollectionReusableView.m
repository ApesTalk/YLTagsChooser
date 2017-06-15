//
//  YLCollectionReusableView.m
//  YLTagsChooser
//
//  Created by TK-001289 on 2016/10/31.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLCollectionReusableView.h"

@implementation YLCollectionReusableView
- (void)prepareForReuse
{
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        UILabel *textLabel = [[UILabel alloc]initWithFrame:self.bounds];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = @"This is a section header";
        [self addSubview:textLabel];
    }
    return self;
}

@end
