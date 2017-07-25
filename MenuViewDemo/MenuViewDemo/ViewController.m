//
//  ViewController.m
//  MenuViewDemo
//
//  Created by tdx on 2017/7/25.
//  Copyright © 2017年 sjjvenu. All rights reserved.
//

#import "ViewController.h"
#import "SCLearnHistoryViewController.h"
#import "SCMultiMediaViewController.h"
#import "SCMultiMediaViewController2.h"

@interface ViewController ()

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

- (IBAction)btnFewClick:(id)sender {
    SCLearnHistoryViewController *vc = [[SCLearnHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnStandMenuClick:(id)sender {
    SCMultiMediaViewController *vc = [[SCMultiMediaViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnMenuExClick:(id)sender {
    SCMultiMediaViewController2 *vc = [[SCMultiMediaViewController2 alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
