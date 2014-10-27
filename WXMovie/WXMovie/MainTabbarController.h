//
//  MainTabbarController.h
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabbarController : UITabBarController<UINavigationControllerDelegate> {
    UIImageView *tbBJImageView;
}
@end

@interface UITabBarController ()

- (void)showTabbar;
- (void)hideTabbar;

@end