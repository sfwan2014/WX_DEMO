//
//  MainTabbarController.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MainTabbarController.h"
#import "NortUSAViewController.h"
#import "NewsViewController.h"
#import "TopViewController.h"
#import "CinemaViewController.h"
#import "MoreViewController.h"
#import "WXNavigationController.h"
#import "WXTabbarItem.h"

@interface MainTabbarController ()

@end

@implementation MainTabbarController {
    UIImageView *_selectImageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _initViewContollers];
    
    [self _initTabbar];
}

//创建子控制器
- (void)_initViewContollers {
    //创建子控制器
    NortUSAViewController *nort = [[NortUSAViewController alloc] init];
    NewsViewController *news = [[NewsViewController alloc] init];
    TopViewController *top = [[TopViewController alloc] init];
    CinemaViewController *cinema = [[CinemaViewController alloc] init];
    MoreViewController *more = [[MoreViewController alloc] init];
    
    //存储三级控制器
    NSArray *viewCtrl = @[nort,news,top,cinema,more];
    
    //存储二级导航控制器
    NSMutableArray *veiwControllers = [NSMutableArray arrayWithCapacity:viewCtrl.count];
    for (int i=0; i<viewCtrl.count; i++) {
        UIViewController *viewController = viewCtrl[i];
        viewController.hidesBottomBarWhenPushed = NO;
        
        //创建二级导航控制器
        WXNavigationController *nav = [[WXNavigationController alloc] initWithRootViewController:viewController];
        nav.delegate = self;
        [veiwControllers addObject:nav];
        [nav release];
    }
    
    self.viewControllers = veiwControllers;
    
    [nort release];
    [news release];
    [top release];
    [cinema release];
    [more release];
    
}

//创建标签工具类
- (void)_initTabbar {
        
    //1.移除自带的tabbar工具类
//    [self.tabBar removeFromSuperview];
    self.tabBar.hidden = YES;
    
    //2.创建自定义tabbar背景
    tbBJImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    tbBJImageView.userInteractionEnabled = YES;
    tbBJImageView.image = [UIImage imageNamed:@"tab_bg_all.png"];
    [self.view addSubview:tbBJImageView];
    [tbBJImageView release];
    
    //4.创建选中的图片
    _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 2, 50, 45)];
    _selectImageView.image = [UIImage imageNamed:@"selectTabbar_bg_all1.png"];
    [tbBJImageView addSubview:_selectImageView];
    
    
    //3.创建自定义tabbar上的按钮
    NSArray *imgArray = @[@"movie_home.png",@"msg_new.png",@"start_top250.png",@"icon_cinema.png",@"more_setting.png"];
    NSArray *titleArray = @[@"电影",@"新闻",@"top",@"影院",@"更多"];
    
    float width = kScreenWidth/imgArray.count;
    
    for (int i=0; i<imgArray.count; i++) {
        NSString *imageName = imgArray[i];
        NSString *title = titleArray[i];
        
        CGRect frame = CGRectMake(width*i, 0, width, 49);
        WXTabbarItem *item = [[WXTabbarItem alloc] initWithFrame:frame
                                                       imageName:imageName
                                                           title:title];
        item.tag = i;
        [item addTarget:self action:@selector(tabbarItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [tbBJImageView addSubview:item];
        [item release];
    }    
}

- (void)tabbarItemSelected:(WXTabbarItem *)item {
    //切换子控制器
    self.selectedIndex = item.tag;
    
    [UIView beginAnimations:@"kTabbarSelect" context:nil];
    [UIView setAnimationDuration:0.2];
    //设置中心点坐标
    _selectImageView.center = item.center;
    [UIView commitAnimations];
    
}

- (void)showTabbar {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    tbBJImageView.left = 0;
    [UIView commitAnimations];
}

- (void)hideTabbar {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    tbBJImageView.left = -kScreenWidth;
    [UIView commitAnimations];
}

#pragma mark - UINavigationController delegte
//导航控制器导航时，将要显示子控制器时
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {

    //子控制器个数
    int count = navigationController.viewControllers.count;

    if (count == 2) {
        [self hideTabbar];
    }    
    else if(count == 1) {
        [self showTabbar];
    }
    
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//}

#pragma mark - 控制旋转
- (BOOL)shouldAutorotate
{
    return NO;
}


@end
