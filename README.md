# MenuView

MenuView为菜单栏目，适用于新闻类app，支持滑动、点击切换栏目

使用方法，将MenuViewDemo中的MenuViewBase拖入需要编辑的工程中去，有以下三种不同使用场景

#一、少量栏目的菜单
示例代码，创建MenuView

```objc
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
```
实现代理，有两个代码需要实现

```objc
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
```

![image](http://wx2.sinaimg.cn/mw690/a9a6744agy1fhw6hkvbb5j20bi0l274k.jpg)

#二、很多栏目的菜单
具体实现参见demo中的SCMultiMediaBaseViewController类示例，此方法适用于同一类型的viewcontroller，并支持缓存，可设置countLimit来控制内存中类的数量
![image](http://wx3.sinaimg.cn/mw690/a9a6744agy1fhw6li8okmj20bi0l2aad.jpg)

#三、带编辑和小红点模式栏目的菜单
参考demo中的SCMultiMediaBaseViewController2类示例
![image](http://wx4.sinaimg.cn/mw690/a9a6744agy1fhw6ndmyfdj20bi0l2mxj.jpg)
![image](http://wx2.sinaimg.cn/mw690/a9a6744agy1fhw6ndtmavj20bi0l2wez.jpg)
 
