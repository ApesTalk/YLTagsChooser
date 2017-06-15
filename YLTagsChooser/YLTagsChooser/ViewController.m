//
//  ViewController.m
//  YLTagsChooser
//
//  Created by TK-001289 on 16/6/13.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "ViewController.h"
#import "YLTagsChooser.h"
#import "YLTag.h"

@interface ViewController ()<YLTagsChooserDelegate>
{
    NSMutableArray *selectedTags;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    selectedTags = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseTags:(id)sender {
    _textLabel.text = nil;
    YLTagsChooser *chooser = [[YLTagsChooser alloc]initWithBottomHeight:400 maxSelectCount:5 delegate:self];
    NSArray *tags = @[@"篮球",
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
                     @"弹球"
                     ];
    NSInteger index = tags.count;
    NSMutableArray *testTags = [NSMutableArray array];
    for(NSInteger i = 0; i < index; i++){
        YLTag *tag = [[YLTag alloc]initWithId:i name:tags[i]];
        [testTags addObject:tag];
    }
    for(NSInteger i = index; i < index + 40; i++){
        NSString *name;
        if(i % 3 == 0){
            name = [NSString stringWithFormat:@"测试%li",i];
        }else if (i % 3 == 1){
            name = [NSString stringWithFormat:@"测试数%li",i];
        }else{
            name = [NSString stringWithFormat:@"测试数据%li",i];
        }
        YLTag *tag = [[YLTag alloc]initWithId:i name:name];
        [testTags addObject:tag];
    }
    index += 40;
    for(NSInteger i = index; i < index + 30; i++){
        NSString *name;
        if(i % 3 == 0){
            name = [NSString stringWithFormat:@"优%li",i];
        }else if (i % 3 == 1){
            name = [NSString stringWithFormat:@"优蓝%li",i];
        }else{
            name = [NSString stringWithFormat:@"优蓝网%li",i];
        }
        YLTag *tag = [[YLTag alloc]initWithId:i name:name];
        [testTags addObject:tag];
    }
    index += 30;
    for(NSInteger i = index; i < index + 20; i++){
        NSString *name;
        if(i % 3 == 0){
            name = [NSString stringWithFormat:@"标签%li",i];
        }else if (i % 3 == 1){
            name = [NSString stringWithFormat:@"Lambert%li",i];
        }else{
            name = [NSString stringWithFormat:@"CodeNinja%li",i];
        }
        YLTag *tag = [[YLTag alloc]initWithId:i name:name];
        [testTags addObject:tag];
    }
    [chooser showInView:self.view];
    [chooser refreshWithTags:testTags selectedTags:selectedTags];
}


#pragma mark---YLTagsChooserDelegate
- (void)tagsChooser:(YLTagsChooser *)sheet selectedTags:(NSArray *)sTags
{
    [selectedTags removeAllObjects];
    [selectedTags addObjectsFromArray:sTags];
    NSString *tagStr = [sTags componentsJoinedByString:@"\n"];
    NSString *result = [NSString stringWithFormat:@"你选择了以下标签：\n%@",tagStr];
    _textLabel.text = result;
}

@end
