//
//  AppDelegate.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

//其他的app 通过url打开此应用调用的协议方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"url=%@",url);
    
    return YES;
}

- (void)loadMain {
    
    //1.初始化新浪微博对象
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    self.sinaWeibo = [[[SinaWeibo alloc] initWithAppKey:kAppKey
                                              appSecret:kAppSecret
                                         appRedirectURI:kAppRedirectURI
                                            andDelegate:self] autorelease];
    
    _sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    _sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
    _sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    
    
    //2.创建控制器
    MainViewController *mainCtrl = [[MainViewController alloc] init];
    LeftViewController *leftCtrl = [[LeftViewController alloc] init];
    RightViewController *rightCtrl = [[RightViewController alloc] init];
    
    MMDrawerController *mmDrawer = [[MMDrawerController alloc]
                                    initWithCenterViewController:mainCtrl
                                    leftDrawerViewController:leftCtrl
                                    rightDrawerViewController:rightCtrl];
    
    //设置左右菜单的宽度
    [mmDrawer setMaximumLeftDrawerWidth:160.0f];
    [mmDrawer setMaximumRightDrawerWidth:80.0f];
    
    //设置手势操作的区域
    [mmDrawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmDrawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //配置管理动画的block
    [mmDrawer
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    //设置动画类型
    [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = MMDrawerAnimationTypeSlideAndScale;
    [MMExampleDrawerVisualStateManager sharedManager].rightDrawerAnimationType = MMDrawerAnimationTypeSlide;
    
    
    self.window.rootViewController = mmDrawer;
    [mmDrawer release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];

    //1.判断是否有授权认证信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"]
        && [sinaweiboInfo objectForKey:@"ExpirationDateKey"]
        && [sinaweiboInfo objectForKey:@"UserIDKey"]) {
        
        //进入首页
        [self loadMain];
        
    } else {
        
        //登陆界面
        self.window.rootViewController = [[[LoginViewController alloc] init] autorelease];
    }
    
    return YES;
}

@end
