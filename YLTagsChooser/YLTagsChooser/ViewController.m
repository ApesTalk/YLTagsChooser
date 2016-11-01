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
    YLTagsChooser *chooser = [[YLTagsChooser alloc]initWithBottomHeight:400 maxSelectCount:5 delegate:self];
    NSMutableArray *testTags = [@[@"篮球",
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
                          @"克郎球",
                          @"橄榄球",
                          @"曲棍球",
                          @"水球",
                          @"马球",
                          @"保龄球",
                          @"健身球",
                          @"门球",
                          @"弹球",
                          ]mutableCopy];
    for(NSInteger i = 0; i < 40; i++){
        if(i % 3 == 0){
            [testTags addObject:[NSString stringWithFormat:@"测%li",i]];
        }else if (i % 3 == 1){
            [testTags addObject:[NSString stringWithFormat:@"测试%li",i]];
        }else{
            [testTags addObject:[NSString stringWithFormat:@"测试数据%li",i]];
        }
    }
    for(NSInteger i = 0; i < 30; i++){
        if(i % 3 == 0){
            [testTags addObject:[NSString stringWithFormat:@"优%li",i]];
        }else if (i % 3 == 1){
            [testTags addObject:[NSString stringWithFormat:@"优蓝%li",i]];
        }else{
            [testTags addObject:[NSString stringWithFormat:@"优蓝网%li",i]];
        }
    }
    for(NSInteger i = 0; i < 20; i++){
        if(i % 3 == 0){
            [testTags addObject:[NSString stringWithFormat:@"标签%li",i]];
        }else if (i % 3 == 1){
            [testTags addObject:[NSString stringWithFormat:@"Lambert%li",i]];
        }else{
            [testTags addObject:[NSString stringWithFormat:@"CodeNinja%li",i]];
        }
    }
    [chooser showInView:self.view];
    [chooser refreshWithTags:testTags];
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
