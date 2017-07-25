//
//  TestViewController.h
//  MenuViewDemo
//
//  Created by tdx on 2017/7/25.
//  Copyright © 2017年 sjjvenu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewItem;
@interface TestViewController : UIViewController

@property (nonatomic, copy)NSString *testTitle;
@property (nonatomic,strong) MenuViewItem* item;

@end
