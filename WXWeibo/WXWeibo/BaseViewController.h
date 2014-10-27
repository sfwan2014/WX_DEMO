//
//  BaseViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"
#import "WXDataService.h"

@interface BaseViewController : UIViewController<SinaWeiboRequestDelegate> {
    UIView *_tipView;
    UIWindow *_tipWindow;
}

@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,assign)BOOL isModalButton;
@property(nonatomic,readonly)MBProgressHUD *hud;
@property(nonatomic,retain)NSMutableArray *requests;


- (SinaWeibo *)sinaweibo;

//加载提示
- (void)showLoading:(BOOL)show;
//显示hud加载提示
- (void)showHUD:(NSString *)title;
- (void)showWindowHUD:(NSString *)title;
//两种隐藏hud的方式
- (void)hideHUD;  //直接隐藏
- (void)hideHUDWithComplete:(NSString *)title;  //隐藏之前显示操作完成的提示

//状态栏上的提示
- (void)showStatusTip:(NSString *)title show:(BOOL)show;


@end
