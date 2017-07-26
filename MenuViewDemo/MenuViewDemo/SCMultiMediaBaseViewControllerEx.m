//
//  SCMultiMediaBaseViewControllerEx.m
//  MenuViewDemo
//
//  Created by tdx on 2017/7/25.
//  Copyright © 2017年 sjjvenu. All rights reserved.
//

#import "SCMultiMediaBaseViewControllerEx.h"
#import "UIView+Extension.h"
#import "ZTPage.h"
#import "TestViewController.h"
#import "MenuViewBtn.h"

@interface SCMultiMediaBaseViewControllerEx ()<UIScrollViewDelegate,MenuViewDelegate,NSCacheDelegate>
@property (nonatomic,weak)MenuView *menuView;
@property (nonatomic,weak)UIButton *moreButton;
@property (nonatomic,strong)UIScrollView *detailScrollView;
@property (nonatomic,strong)NSArray *subviewControllers;
@property (nonatomic,strong)NSMutableArray *controllerFrames;
@property (nonatomic,weak)UIViewController *selectedViewConTroller;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *items;
//正在出现的控制器
@property (nonatomic,strong)NSMutableDictionary *displayVC;
@property (nonatomic,assign)int  selectedIndex;
//内存管理机制，设置countlimit可以使内存机制中存储控制器的最大数量
@property (nonatomic,strong)NSCache *controllerCache;


@end

@implementation SCMultiMediaBaseViewControllerEx

#pragma mark Lazy load
- (NSArray *)titles
{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)menuTitles
{
    if (_menuTitles == nil)
    {
        _menuTitles = [[NSMutableArray alloc] init];
    }
    return _menuTitles;
}
- (NSMutableArray *)menuFixTitles
{
    if (_menuFixTitles == nil)
    {
        _menuFixTitles = [[NSMutableArray alloc] init];
    }
    return _menuFixTitles;
}

- (NSMutableArray *)hideTitles
{
    if (_hideTitles == nil)
    {
        _hideTitles = [[NSMutableArray alloc] init];
    }
    return _hideTitles;
}

- (NSMutableDictionary *)displayVC
{
    if (_displayVC == nil) {
        _displayVC = [NSMutableDictionary dictionary];
    }
    return _displayVC;
}
- (NSArray *)subviewControllers
{
    if (_subviewControllers == nil) {
        _subviewControllers = [NSMutableArray array];
    }
    return _subviewControllers;
}

- (UIScrollView *)detailScrollView
{
    if (_detailScrollView == nil) {
        self.detailScrollView = [[UIScrollView alloc]init];
        self.detailScrollView.backgroundColor = [UIColor whiteColor];
        self.detailScrollView.pagingEnabled = YES;
        self.detailScrollView.delegate = self;
        [self.view addSubview:self.detailScrollView];
    }
    return _detailScrollView;
}

- (NSMutableArray *)controllerFrames
{
    if (_controllerFrames == nil) {
        _controllerFrames = [NSMutableArray array];
    }
    return _controllerFrames;
}

- (NSCache *)controllerCache
{
    if (_controllerCache == nil) {
        _controllerCache = [[NSCache alloc] init];
        // 设置数量限制
        _controllerCache.countLimit = 4;
        _controllerCache.delegate = self;
    }
    return _controllerCache;
}

- (void)setSelectedViewConTroller:(UIViewController *)selectedViewConTroller
{
    _selectedViewConTroller = selectedViewConTroller;
}

#pragma mark 加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithMneuViewStyle:(MenuViewStyle)style
{
    if (self = [super init]) {
        switch (style) {
            case MenuViewStyleLine:
                self.style = MenuViewStyleLine;
                break;
            case MenuViewStyleFoold:
                self.style = MenuViewStyleFoold;
                break;
            case MenuViewStyleFooldHollow:
                self.style = MenuViewStyleFooldHollow;
                break;
            default:
                self.style = MenuViewStyleDefault;
                break;
        }
    }
    return self;
}

- (void)loadVC:(NSArray *)viewcontrollerClass AndItems:(NSArray *)items
{
    NSMutableArray *itemTitles = [[NSMutableArray alloc] init];
    for (int i = 0; i < items.count; i++)
    {
        MenuViewItem *data = [items objectAtIndex:i];
        [itemTitles addObject:data.title];
    }
    self.items = items;
    [self loadVC:viewcontrollerClass AndTitle:itemTitles];
}

- (void)loadVC:(NSArray *)viewcontrollerClass AndTitle:(NSArray *)titles
{
    self.subviewControllers = viewcontrollerClass;
    self.titles  = titles;
    [self loadMenuViewWithTitles:self.titles];
}

- (void)loadMenuViewWithTitles:(NSArray *)titles
{
    if (self.menuView != nil)
    {
        [self.menuView removeFromSuperview];
        self.menuView = nil;
    }
    MenuView *Menview = [[MenuView alloc] initWithMneuViewStyle:self.style AndItems:self.items hasMiddleLine:NO];
    Menview.bAutoLayout = NO;
    [self.view addSubview:Menview];
    Menview.delegate = self;
    self.menuView = Menview;
    
    if (self.moreButton != nil)
    {
        [self.moreButton removeFromSuperview];
        self.moreButton = nil;
    }
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateSelected];
    self.moreButton = button;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    float fversion=[[[UIDevice currentDevice]systemVersion] floatValue];
    CGFloat y =  NavigationBarHeight;
    if (fversion >= 7.0)
        y += 20;
    double MoreButtonWidth = 40;
    
    self.menuView.frame = CGRectMake(0, y, UIScreenWidth-MoreButtonWidth, MenuHeight);
    
    [self.controllerFrames removeAllObjects];
    
    for (int j = 0; j < self.subviewControllers.count; j++) {
        CGFloat X = j * UIScreenWidth;
        CGFloat Y = 0;
        CGFloat height = UIScreenHeight - y - self.menuView.frame.size.height;
        CGRect frame = CGRectMake(X, Y, UIScreenWidth, height);
        [self.controllerFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    //如果不是在tabbar中需要将MenuView的y值设置为Y+20（导航控制器高度+状态栏高度）
    self.detailScrollView.frame = CGRectMake(0, self.menuView.frame.origin.y+self.menuView.frame.size.height, UIScreenWidth,UIScreenHeight - y - self.menuView.frame.size.height);
    self.detailScrollView.contentSize = CGSizeMake(self.subviewControllers.count * self.detailScrollView.frame.size.width, self.detailScrollView.frame.size.height);
    
    self.detailScrollView.backgroundColor = [UIColor whiteColor];
    self.detailScrollView.showsHorizontalScrollIndicator = NO;
    
    if (self.selectedViewConTroller == nil)
        [self addViewControllerViewAtIndex:0];
    
    self.moreButton.frame = CGRectMake(UIScreenWidth-MoreButtonWidth, y, MoreButtonWidth, MenuHeight);
    
    [self.view bringSubviewToFront:self.moreButton];
}

- (void)resetPosition
{
    self.detailScrollView.contentOffset = CGPointZero;
}


- (void)addViewControllerViewAtIndex:(int)index
{
    if (self.subviewControllers.count == 0 || _menuTitles.count == 0)
        return;
    Class vclass = self.subviewControllers[index];
    TestViewController *vc = [[vclass alloc]init];
    vc.testTitle = self.menuTitles[index];
    vc.view.frame = [self.controllerFrames[index] CGRectValue];
    [self.displayVC setObject:vc forKey:@(index)];
    [self addChildViewController:vc];
    [self.detailScrollView addSubview:vc.view];
    self.selectedViewConTroller = vc;
}

- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index{
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayVC removeObjectForKey:@(index)];
    
    if ([self.controllerCache objectForKey:@(index)]) return;
    [self.controllerCache setObject:viewController forKey:@(index)];
    
}

- (BOOL)isInScreen:(CGRect)frame{
    CGFloat x = frame.origin.x;
    CGFloat ScreenWith = self.detailScrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.detailScrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) >contentOffsetX && x - contentOffsetX < ScreenWith ){
        return YES;
    }else{
        return NO;
    }
    
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index{
    [self addChildViewController:viewController];
    [self.detailScrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
    
    self.selectedViewConTroller = viewController;
}

#pragma mark delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int Page = (int)(scrollView.contentOffset.x/self.view.width + 0.5);
    int index = (int)(scrollView.contentOffset.x/self.view.width);
    CGFloat rate = scrollView.contentOffset.x/self.view.width;
    for (int i = 0; i <self.subviewControllers.count; i++) {
        //取出frame
        if (i >= self.controllerFrames.count)
            break;
        CGRect frame = [self.controllerFrames[i] CGRectValue];
        //首先从显示中的控制器中取；
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (vc == nil) {//从内存中取
                vc = [self.controllerCache objectForKey:@(i)];
                if (vc) {//把内存中的取出来创建，保证此控制器是之前消除的控制器
                    [self addCachedViewController:vc atIndex:i];
                    if (i < self.controllerFrames.count)
                        self.selectedViewConTroller.view.frame = [self.controllerFrames[i] CGRectValue];
                }else{//再创建
                    [self addViewControllerViewAtIndex:i];
                }
            }
        }else{
            if (vc) {//如果不在屏幕中显示，将其移除
                [self removeViewController:vc atIndex:i];
            }
        }
    }
    self.selectedIndex = index;
    self.selectedViewConTroller = [self.displayVC objectForKey:@(Page)];
    //滚动使MenuView中的item移动
    [self.menuView SelectedBtnMoveToCenterWithIndexMoving:index WithRate:rate];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width )return;
    int Page = (int)(scrollView.contentOffset.x/self.view.width);
    
    //用的UItabbar做的展示，所以切换tabar的时候，会出现控制器不清除的结果，使得通知中心紊乱，其他控制器也可以接收当前控制器发送的通知，所以，我把通知名称设置为唯一的；
    NSString *name  = [NSString stringWithFormat:@"scrollViewDidFinished%@",self.menuView];
    NSDictionary *info = @{
                           @"index":@(Page)};
    [[NSNotificationCenter defaultCenter]postNotificationName:name  object:nil userInfo:info];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width )return;
    
    int Page = (int)(scrollView.contentOffset.x/UIScreenWidth);
    
    if (Page == 0) {
        [self.menuView selectWithIndex:Page AndOtherIndex:Page + 1 ];
    }else if (Page == self.subviewControllers.count - 1){
        [self.menuView selectWithIndex:Page AndOtherIndex:Page - 1];
    }else{
        [self.menuView selectWithIndex:Page AndOtherIndex:Page + 1 ];
        [self.menuView selectWithIndex:Page AndOtherIndex:Page - 1];
    }
}


- (void)MenuViewDelegate:(MenuView *)menuciew WithIndex:(int)index
{
    
    [self removeViewController:self.selectedViewConTroller atIndex:_selectedIndex];
    
    self.detailScrollView.contentOffset = CGPointMake(index * UIScreenWidth, 0);
    self.selectedIndex = index;
    
    UIViewController *vc = [self.displayVC objectForKey:@(index)];
    if (vc == nil) {
        vc = [self.controllerCache objectForKey:@(index)];
        if (vc) {
            [self addCachedViewController:vc atIndex:index];
        }else{
            [self addViewControllerViewAtIndex:index];
        }
    }
}


- (void)btnMoreClick:(id)sender
{
    
}
@end
