//
//  ViewController.m
//  YLTagsChooser
//
//  Created by TK-001289 on 16/6/13.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "ViewController.h"
#import "YLTagsChooser.h"

@interface ViewController ()<YLTagsChooserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseTags:(id)sender {
    _textLabel.text = nil;
    YLTagsChooser *chooser = [[YLTagsChooser alloc]initWithBottomHeight:300 maxSelectCount:5 delegate:self];
    NSArray *testTags = @[@"篮球",
                          @"足球",
                          @"羽毛球",
                          @"乒乓球",
                          @"排球",
                          @"网球",
                          @"高尔夫球",
                          @"冰球",
                          @"沙滩排球",
                          @"棒球",
                          @"垒球",
                          @"藤球",
                          @"毽球",
                          @"台球",
                          @"鞠蹴",
                          @"板球",
                          @"壁球",
                          @"沙壶",
                          @"冰壶",
                          @"克郎球",
                          @"橄榄球",
                          @"曲棍球",
                          @"水球",
                          @"马球",
                          @"保龄球",
                          @"健身球",
                          @"门球",
                          @"弹球",
                          ];
    [chooser refreshWithTags:testTags];
    [chooser showInView:self.view];
}


#pragma mark---YLTagsChooserDelegate
- (void)tagsChooser:(YLTagsChooser *)sheet selectedTags:(NSArray *)sTags
{
    NSString *result = @"你选择了以下标签：\n";
    for(NSString *str in sTags){
        result = [result stringByAppendingFormat:@"%@\n",str];
    }
    _textLabel.text = result;
}

@end
