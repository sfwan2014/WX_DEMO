//
//  MainViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MainViewController.h"
#import "WXNavigationController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "MoreViewController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"
#import "UIViewController+MMDrawerController.h"

@interface MainViewController ()<SinaWeiboRequestDelegate>

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeDidChangeNofitication object:nil];
    }
    return self;
}

//隐藏未读微博数图标
- (void)hiddenBadge {
    _badgeView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建子控制器
    [self _initViewControllers];
    
    //2.创建自定义tabbar工具栏
    [self _initTabbarView];
    
    //3.加载背景图片
    [self loadImage];
    
    //4.实时请求更新未读消息
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
//    [self timeAction];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化子控制器
- (void)_initViewControllers {
    //1.创建三级控制器
    HomeViewController *home = [[[HomeViewController alloc] init] autorelease];
    MessageViewController *message = [[[MessageViewController alloc] init] autorelease];
    ProfileViewController *profile = [[[ProfileViewController alloc] init] autorelease];
    profile.isLoginUser = YES;
    DiscoverViewController *discover = [[[DiscoverViewController alloc] init] autorelease];
    MoreViewController  *more = [[[MoreViewController alloc] init] autorelease];
    
    //2.创建二级控制器(导航控制器)
    NSArray *viewControllers = @[home,message,profile,discover,more];
    NSMutableArray *viewCtrs = [NSMutableArray arrayWithCapacity:5];
    for (UIViewController *viewController in viewControllers) {
        WXNavigationController *navigation = [[WXNavigationController alloc] initWithRootViewController:viewController];
        [viewCtrs addObject:navigation];
        [navigation release];
        
        navigation.delegate = self;
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    //3.将二级控制器交给一级控制器管理
    self.viewControllers = viewCtrs;
}

//自定义tabbar工具栏
- (void)_initTabbarView {
    //1.隐藏内置的tabbar工具栏
    [self.tabBar setHidden:YES];
    
    _tabbarView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    _tabbarView.imgName = @"mask_navbar.png";
    _tabbarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabbarView];
    
    _selectImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, (49-45)/2, 64, 45)];
    _selectImgView.imgName = @"home_bottom_tab_arrow.png";
    [_tabbarView addSubview:_selectImgView];
    
    
    NSArray *background = @[@"home_tab_icon_1.png",
                            @"home_tab_icon_2.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png"];    
    
    float itemWidth = kScreenWidth/5;
    for (int i=0; i<background.count; i++) {
        NSString *imageName = background[i];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectZero];
        button.imgName = imageName;
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake((itemWidth-64)/2+(i*itemWidth), (49-45)/2, 64, 45);
        button.tag = i;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
}

#pragma mark - actons
- (void)selectedTab:(UIButton *)button {
    self.selectedIndex = button.tag;
    
    [UIView animateWithDuration:0.2 animations:^{
        _selectImgView.center = button.center;
    }];
}

//是否显示工具栏
- (void)hiddenTabbar:(BOOL)hidden {
    if (hidden) {
        _tabbarView.left = -kScreenWidth;
    } else {
        _tabbarView.left = 0;
    }
    
    self.tabBar.hidden = YES;
}

- (void)themeChangeAction:(NSNotification *)notification {
    [self loadImage];
}

- (void)loadImage {
    UIImage *bjImg = [[ThemeManager shareInstance] getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bjImg];
    
    UIImage *maskImg = [[ThemeManager shareInstance] getThemeImage:@"mask_bg.jpg"];
    self.mm_drawerController.view.backgroundColor = [UIColor colorWithPatternImage:maskImg];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    //子控制器的个数
    int count = navigationController.viewControllers.count;
    
    if (count == 1) {
        //显示工具栏
        [self hiddenTabbar:NO];
    } else {
        //隐藏工具栏
        [self hiddenTabbar:YES];
    }    
}

- (void)timeAction {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    
//    NSString *userId = sinaWeibo.userID;
    
    [sinaWeibo requestWithURL:unread_count
                       params:nil httpMethod:@"GET" delegate:self];
    
//    [self performSelector:@selector(timeAction) withObject:nil afterDelay:30];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(NSDictionary *)result {
    if (_badgeView == nil) {
        _badgeView = [[ThemeImageView alloc] initWithFrame:CGRectMake(64-32, 0, 32, 32)];
        _badgeView.imgName = @"number_notify_9.png";
        [_tabbarView addSubview:_badgeView];
        
        ThemeLabel *badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeView.bounds];
        badgeLabel.colorKeyName = @"Timeline_Notice_color";
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.tag = 100;
        [_badgeView addSubview:badgeLabel];
        [badgeLabel release];
    }
    
    //新微博未读数
    NSNumber *status = [result objectForKey:@"status"];
    int unRead = [status intValue];
    if (unRead > 0) {
        _badgeView.hidden = NO;
        
        if (unRead >= 100) {
            unRead = 99;
        }
        
        UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:100];
        badgeLabel.text = [NSString stringWithFormat:@"%d",unRead];
        
    } else {
        _badgeView.hidden = YES;
    }
}

@end
