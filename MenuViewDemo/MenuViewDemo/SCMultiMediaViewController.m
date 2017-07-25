//
//  SCMultiMediaViewController.m
//  SmartCampusiOS
//
//  Created by tdx on 2017/6/26.
//  Copyright © 2017年 SmartCampus. All rights reserved.
//

#import "SCMultiMediaViewController.h"
#import "TestViewController.h"

@implementation SCMultiMediaViewController

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
    
    NSArray *array = @[@"真题",@"视频",@"音频",@"PPT",@"文档"];
    self.menuTitles = [array mutableCopy];
    
    Class vc1 = [TestViewController class];
    NSMutableArray *vcclass = [[NSMutableArray alloc] init];
    for (int i = 0 ;i < self.menuTitles.count; i++)
    {
        [vcclass addObject:vc1];
    }
    
    [self loadVC:vcclass AndTitle:self.menuTitles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
