//
//  ThemeManager.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeManager.h"

#define kDefaultThemeName @"猫爷"
#define kThemeName @"themeName"

static ThemeManager *instace = nil;

@implementation ThemeManager

+ (ThemeManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instace = [[[self class] alloc] init];
    });
    
    return instace;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themeConfig = [NSDictionary dictionaryWithContentsOfFile:themePath];
        
        self.themeName = kDefaultThemeName;
        
        NSString *saveThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if (saveThemeName.length > 0) {
            self.themeName = saveThemeName;
        }
    }
    
    return self;
}

//主题名称的设置器方法，当前更换主题时，会调用此方法
- (void)setThemeName:(NSString *)themeName {
    
    if (_themeName != themeName) {
        [_themeName release];
        _themeName = [themeName copy];
    }
    
    //读取当前主题下的字体配置文件
    NSString *themePath = [self themePath];
    NSString *fontConfigPath = [themePath stringByAppendingPathComponent:@"config.plist"];
    self.fontConfig = [NSDictionary dictionaryWithContentsOfFile:fontConfigPath];
    
}

//获取当前主题下的图片数据
- (UIImage *)getThemeImage:(NSString *)imageName {
    if (imageName.length == 0) {
        return nil;
    }
    
    //当前主题的路径
    NSString *themePath = [self themePath];
    
    NSString *imgPath = [themePath stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    
    return image;
}

//获取当前主题下对应的颜色
- (UIColor *)getThemeColor:(NSString *)fontName {
    if (fontName.length == 0) {
        return nil;
    }
    
    NSDictionary *rgbDic = [self.fontConfig objectForKey:fontName];
    float r = [[rgbDic objectForKey:@"R"] floatValue];
    float g = [[rgbDic objectForKey:@"G"] floatValue];
    float b = [[rgbDic objectForKey:@"B"] floatValue];
    
    UIColor *color = rgb(r, g, b, 1);
    return color;
}

- (NSString *)getLinkColor:(NSString *)fontName {
    if (fontName.length == 0) {
        return nil;
    }
    
    NSDictionary *rgbDic = [self.fontConfig objectForKey:fontName];
    int r = [[rgbDic objectForKey:@"R"] intValue];
    int g = [[rgbDic objectForKey:@"G"] intValue];
    int b = [[rgbDic objectForKey:@"B"] intValue];
    
    NSString *colorText = [NSString stringWithFormat:@"#%02x%02x%02x",r,g,b];
    
    return colorText;
    
}

//获取到当前主题的路径
- (NSString *)themePath {
    //1.获取程序包的根路径
    NSString *rootPath = [[NSBundle mainBundle] resourcePath];
    
    //2.获取当前主题对应的子路径
    NSString *themePath = [self.themeConfig objectForKey:self.themeName];
    
    NSString *path = [rootPath stringByAppendingPathComponent:themePath];
    
    return path;
    
}

//保存主题
- (void)saveTheme {
    [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
