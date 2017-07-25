//
//  SCMultiMediaViewController2ViewController.m
//  MenuViewDemo
//
//  Created by tdx on 2017/7/25.
//  Copyright © 2017年 sjjvenu. All rights reserved.
//

#import "SCMultiMediaViewController2.h"
#import "TestViewController.h"
#import "EditViewController.h"
#import "MenuViewBtn.h"

@interface SCMultiMediaViewController2 ()

@end

@implementation SCMultiMediaViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;
    rect.origin.y=0;
    
    rect.size.height = rect.size.height - self.navigationController.navigationBar.frame.size.height;
    float fversion=[[[UIDevice currentDevice]systemVersion] floatValue];
    if(fversion>=7.0)
    {
        rect.size.height = rect.size.height - 20;
    }
    
    self.menuTitles = [@[@"真题测试",@"视频分享",@"音频分享",@"PPT",@"文档",@"语文",@"数学"] mutableCopy];
    self.hideTitles = [@[@"社会",@"人文",@"历史",@"本地"] mutableCopy];
    [self initContentView];
}

- (void)initContentView
{
    
    Class vc1 = [TestViewController class];
    NSMutableArray *vcclass = [[NSMutableArray alloc] init];
    for (int i = 0 ;i < self.menuTitles.count; i++)
    {
        [vcclass addObject:vc1];
    }
    
    NSMutableArray *menuViewItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.menuTitles.count ;i++)
    {
        MenuViewItem *item = [[MenuViewItem alloc] init];
        item.title = [self.menuTitles objectAtIndex:i];
        item.count = 2;
        item.ID = [NSString stringWithFormat:@"%d",i];
        item.type = i;
        [menuViewItems addObject:item];
    }
    
    [self loadVC:vcclass AndItems:menuViewItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btnMoreClick:(id)sender
{
    EditViewController *editV = [[EditViewController alloc] init];
    editV.hidesBottomBarWhenPushed = YES;
    NSMutableArray *array = self.menuTitles;
    [array removeObjectsInArray:self.menuFixTitles];
    editV.showItemsList = array;
    editV.hideItemsList = self.hideTitles;
    __weak __typeof__(self) bself = self;
    [editV setSortCompleteCallBack:^(NSArray *showArray,NSArray *hideArray)
     {
         __strong typeof (self) strongSelf = bself;
         [strongSelf.menuTitles removeAllObjects];
         [strongSelf.menuTitles addObjectsFromArray:strongSelf.menuFixTitles];
         [strongSelf.menuTitles addObjectsFromArray:showArray];
         [strongSelf.hideTitles removeAllObjects];
         [strongSelf.hideTitles addObjectsFromArray:hideArray];
         [strongSelf reloadData];
     }];
    [self.navigationController pushViewController:editV animated:YES];
    editV = nil;
}

- (void)reloadData
{
    [self initContentView];
    [self resetPosition];
}
@end
