//
//  SCMultiMediaBaseViewController.h
//  TdxController
//
//  Created by tdx on 15/12/22.
//  Copyright © 2015年 tdx.com.iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"

@interface SCMultiMediaBaseViewController : UIViewController

@property (nonatomic,assign)MenuViewStyle style;
@property (nonatomic,strong) NSMutableArray *menuTitles;
@property (nonatomic,strong) NSMutableArray *menuFixTitles;
@property (nonatomic,strong) NSMutableArray *hideTitles;

- (void)loadVC:(NSArray *)viewcontrollerClass AndTitle:(NSArray*)titles;
- (void)resetPosition;

- (instancetype)initWithMneuViewStyle:(MenuViewStyle)style;
@end
