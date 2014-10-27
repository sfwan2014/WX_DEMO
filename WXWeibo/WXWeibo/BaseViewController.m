//
//  BaseViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)dealloc {
    WXLog(@"%@ deallc",self);
    [_tipView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isBackButton = YES;
        self.isModalButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.requests = [NSMutableArray array];
    
    //导航控制器子控制器的个数
    int count = self.navigationController.viewControllers.count;
    if ((self.isBackButton && count > 1) || self.isModalButton) {
        //创建返回按钮
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        button.backImgName = @"titlebar_button_back_9.png";
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
        
        [backItem release];
    }
    
    //背景透明
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (SinaWeiboRequest *request in self.requests) {
        [request disconnect];
    }
}

//加载提示
- (void)showLoading:(BOOL)show {
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-20-44-49-20)/2, kScreenWidth, 20)];
        _tipView.backgroundColor = [UIColor clearColor];        
        
        //1.loading视图
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        //2.加载提示的Label
        ThemeLabel *loadLabel = [[ThemeLabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"正在加载...";
        loadLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        [_tipView addSubview:loadLabel];
        
        loadLabel.left = (kScreenWidth-loadLabel.width)/2;
        activityView.right = loadLabel.left-5;
        
        [activityView release];
        [loadLabel release];
    }
    
    if(show) {
        [self.view addSubview:_tipView];
    } else {
        if (_tipView.superview) {
            [_tipView removeFromSuperview];
        }
    }
}

//显示提示
- (void)showHUD:(NSString *)title {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_hud retain];
    }
    
    _hud.labelText = title;
    _hud.dimBackground = YES;
}

- (void)showWindowHUD:(NSString *)title {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        [_hud retain];
    }
    
    _hud.labelText = title;
    _hud.dimBackground = YES;
}

//隐藏提示
- (void)hideHUD {
    [self.hud hide:YES];
}

//操作完成的提示
- (void)hideHUDWithComplete:(NSString *)title  //隐藏之前显示操作完成的提示
{
    self.hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    //显示模式为自定义视图模式
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    
    //延迟隐藏
    [self.hud hide:YES afterDelay:1.5];
}

//状态栏上的提示
- (void)showStatusTip:(NSString *)title show:(BOOL)show {
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        //创建Label
        UILabel *tpLabel = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        tpLabel.backgroundColor = [UIColor clearColor];
        tpLabel.textAlignment = NSTextAlignmentCenter;
        tpLabel.font = [UIFont systemFontOfSize:13.0f];
        tpLabel.textColor = [UIColor whiteColor];
        tpLabel.tag = 2013;
        [_tipWindow addSubview:tpLabel];
        [tpLabel release];
        
        //创建光标
        UIImageView *progress = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"queue_statusbar_progress.png"]];
        progress.frame = CGRectMake(0, 20-6, 100, 6);
        progress.tag = 2014;
        [_tipWindow addSubview:progress];
        [progress release];
    }
    
    UILabel *tpLabel = (UILabel *)[_tipWindow viewWithTag:2013];
    UIImageView *progress = (UIImageView *)[_tipWindow viewWithTag:2014];
    if (show) {
        //不能调用如下方法显示window
//        [_tipWindow makeKeyAndVisible];
        _tipWindow.hidden = NO;
        tpLabel.text = title;
        
        progress.left = 0;
        [UIView animateWithDuration:2 animations:^{
            [UIView setAnimationRepeatCount:1000];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            
            progress.left = kScreenWidth;
        }];
        
    } else {
        tpLabel.text = title;
        progress.hidden = YES;
        
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:2];
    }
    
}

- (void)removeTipWindow {
    _tipWindow.hidden = YES;
    
    //安全释放
    WXRelease(_tipWindow);
}

- (void)backAction {
    if(self.isModalButton) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaWeibo;
}

@end
