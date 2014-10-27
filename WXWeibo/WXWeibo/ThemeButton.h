//
//  ThemeButton.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//normal下显示的图片名称
@property(nonatomic,copy)NSString *imgName;
//高亮状态下显示的图片名称
@property(nonatomic,copy)NSString *highlightImgName;

@property(nonatomic,copy)NSString *backImgName;
@property(nonatomic,copy)NSString *backHighlightImgName;

//标题的颜色key
@property(nonatomic,copy)NSString *colorKeyName;

@end
