//
//  RectButton.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-12.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeButton.h"
#import "ThemeLabel.h"

@interface RectButton : ThemeButton {
    ThemeLabel *_rectTitleLabel;
    ThemeLabel *_subTitleLabel;
}

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subTitle;

@end
