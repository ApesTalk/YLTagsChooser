//
//  YLCollectionReusableView.m
//  YLTagsChooser
//
//  Created by TK-001289 on 2016/10/31.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLCollectionReusableView.h"

@interface YLCollectionReusableView ()
@property(nonatomic,strong)UILabel *textLabel;
@end

@implementation YLCollectionReusableView
- (void)prepareForReuse
{
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        _textLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"This is a section header/footer";
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _textLabel.text = title;
}

@end
