//
//  SCLearnHistoryViewController.m
//  SmartCampusiOS
//
//  Created by tdx on 2017/6/22.
//  Copyright © 2017年 SmartCampus. All rights reserved.
//

#import "SCLearnHistoryViewController.h"
#import "MenuView.h"

@interface SCLearnHistoryViewController ()<MenuViewDelegate,UIScrollViewDelegate>
{
    MenuView                            *m_menuView;
    UIScrollView                        *m_scrollView;
    BOOL                                m_bEditMode;
    UIButton                            *m_editButton;
}

@end

@implementation SCLearnHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect rect = self.view.frame;
    rect.origin.y=0;
    
    rect.size.height = rect.size.height - self.navigationController.navigationBar.frame.size.height;
    CGFloat menuViewY = self.navigationController.navigationBar.frame.size.height;
    float fversion=[[[UIDevice currentDevice]systemVersion] floatValue];
    if(fversion>=7.0)
    {
        rect.size.height = rect.size.height - 20;
        menuViewY += 20;
    }

    NSArray *arrTitles = [[NSArray alloc] initWithObjects:@"考前重难点",@"在线微客堂", nil];
    m_menuView = [[MenuView alloc] initWithMneuViewStyle:MenuViewStyleLine AndTitles:arrTitles hasMiddleLine:NO];
    m_menuView.bAutoLayout = YES;
    m_menuView.delegate = self;
    m_menuView.frame = CGRectMake(0, menuViewY, rect.size.width, 40);
    [self.view addSubview:m_menuView];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, m_menuView.frame.origin.y+m_menuView.frame.size.height, rect.size.width, rect.size.height-m_menuView.frame.size.height)];
    m_scrollView.backgroundColor= [UIColor clearColor];
    [m_scrollView setPagingEnabled:YES];
    m_scrollView.showsHorizontalScrollIndicator = NO;
    m_scrollView.delegate = self;
    [m_scrollView setContentOffset:CGPointZero];
    [self.view addSubview:m_scrollView];
    [m_scrollView setContentSize:CGSizeMake(rect.size.width*2, rect.size.height-m_menuView.frame.size.height)];
    
    UIView *view1= [[UIView alloc] init];
    view1.frame = CGRectMake(0, 0, m_scrollView.frame.size.width, m_scrollView.frame.size.height);
    view1.backgroundColor = [UIColor greenColor];
    [m_scrollView addSubview:view1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.frame = CGRectMake(m_scrollView.frame.size.width, 0, m_scrollView.frame.size.width, m_scrollView.frame.size.height);
    view2.backgroundColor = [UIColor purpleColor];
    [m_scrollView addSubview:view2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MenuViewDelegate

- (void)MenuViewDelegate:(MenuView*)menuview WithIndex:(int)index
{
    [m_scrollView setContentOffset: CGPointMake(m_scrollView.bounds.size.width * index, m_scrollView.contentOffset.y) animated: NO] ;
    
    //[self selectIndex:index];
}

- (void)ClickSelectedDelegate:(MenuView*)menuciew WithIndex:(int)index
{
    
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //int Page = (int)(scrollView.contentOffset.x/self.view.frame.size.width + 0.5);
    int index = (int)(scrollView.contentOffset.x/self.view.frame.size.width);
    CGFloat rate = scrollView.contentOffset.x/self.view.frame.size.width;
    [m_menuView SelectedBtnMoveToCenterWithIndexMoving:index WithRate:rate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width )return;
    
    int Page = (int)(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width);
    
    if (Page == 0)
    {
        [m_menuView selectWithIndex:Page AndOtherIndex:Page + 1];
    }
    else if (Page == 2 - 1)
    {
        [m_menuView selectWithIndex:Page AndOtherIndex:Page - 1];
    }
    else
    {
        [m_menuView selectWithIndex:Page AndOtherIndex:Page + 1];
        [m_menuView selectWithIndex:Page AndOtherIndex:Page - 1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //int Page = (int)(scrollView.contentOffset.x/self.view.frame.size.width + 0.5);
    int index = (int)(scrollView.contentOffset.x/self.view.frame.size.width);
    CGFloat rate = scrollView.contentOffset.x/self.view.frame.size.width;
    [m_menuView SelectedBtnMoveToCenterWithIndex:index WithRate:rate];
}

@end
