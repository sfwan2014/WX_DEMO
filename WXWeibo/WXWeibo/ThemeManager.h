//
//  ThemeManager.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>

//主题切换的通知
#define kThemeDidChangeNofitication @"kThemeDidChangeNofitication"

@interface ThemeManager : NSObject

+ (ThemeManager *)shareInstance;

//当前的主题名称
@property(nonatomic,copy)NSString *themeName;

//主题的映射字典
@property(nonatomic,retain)NSDictionary *themeConfig;

//字体颜色的配置文件
@property(nonatomic,retain)NSDictionary *fontConfig;

//获取当前主题下的图片数据
- (UIImage *)getThemeImage:(NSString *)imageName;

//获取当前主题下对应的颜色
- (UIColor *)getThemeColor:(NSString *)fontName;

//保存主题
- (void)saveTheme;

- (NSString *)getLinkColor:(NSString *)fontName;

@end
