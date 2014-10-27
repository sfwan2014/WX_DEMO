//
//  MainViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeImageView;
@interface MainViewController : UITabBarController<UINavigationControllerDelegate> {
    ThemeImageView *_tabbarView;
    ThemeImageView *_selectImgView;
    
    //未读微博数图标
    ThemeImageView *_badgeView;
    
}

////隐藏未读微博数图标
//- (void)hiddenBadge;

@end

@interface UITabBarController ()
//隐藏未读微博数图标
- (void)hiddenBadge;
@end
