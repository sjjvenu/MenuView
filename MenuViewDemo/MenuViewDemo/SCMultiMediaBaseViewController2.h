//
//  SCMultiMediaBaseViewController2.h
//  MenuViewDemo
//
//  Created by tdx on 2017/7/25.
//  Copyright © 2017年 sjjvenu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"

@interface SCMultiMediaBaseViewController2 : UIViewController

@property (nonatomic,assign)MenuViewStyle style;
@property (nonatomic,strong) NSMutableArray *menuTitles;
@property (nonatomic,strong) NSMutableArray *menuFixTitles;
@property (nonatomic,strong) NSMutableArray *hideTitles;

- (void)loadVC:(NSArray *)viewcontrollerClass AndItems:(NSArray *)items;
- (void)resetPosition;

- (instancetype)initWithMneuViewStyle:(MenuViewStyle)style;

@end
