//
//  ThemeButton.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

- (void)dealloc {
    self.imgName = nil;
    self.highlightImgName = nil;
    self.backImgName = nil;
    self.backHighlightImgName = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofitication object:nil];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib {
    [self initViews];
}

- (void)initViews {
    //监听主题更换的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeDidChangeNofitication object:nil];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
}

- (void)themeChangeAction:(NSNotification *)notification {
    [self loadImage];
}

- (void)setImgName:(NSString *)imgName {
    if (_imgName != imgName) {
        [_imgName release];
        _imgName = [imgName copy];
    }
    
    [self loadImage];
//    ThemeManager *themeManager = [ThemeManager shareInstance];
//    UIImage *img = [themeManager getThemeImage:self.imgName];
//    [self setImage:img forState:UIControlStateNormal];
}

- (void)setHighlightImgName:(NSString *)highlightImgName {
    if (_highlightImgName != highlightImgName) {
        [_highlightImgName release];
        _highlightImgName = [highlightImgName copy];
    }
    
    [self loadImage];
}

- (void)setBackImgName:(NSString *)backImgName {
    if (_backImgName != backImgName) {
        [_backImgName release];
        _backImgName = [backImgName copy];
    }
    
    [self loadImage];
}

- (void)setBackHighlightImgName:(NSString *)backHighlightImgName {
    if (_backHighlightImgName != backHighlightImgName) {
        [_backHighlightImgName release];
        _backHighlightImgName = [backHighlightImgName copy];
    }
    
    [self loadImage];
}

- (void)setColorKeyName:(NSString *)colorKeyName {
    if (_colorKeyName != colorKeyName) {
        [_colorKeyName release];
        _colorKeyName = [colorKeyName copy];
        
        UIColor *titleColor = [[ThemeManager shareInstance]
                               getThemeColor:self.colorKeyName];
        [self setTitleColor:titleColor forState:UIControlStateNormal];        
    }
}

- (void)loadImage {
    ThemeManager *themeManager = [ThemeManager shareInstance];
    
    UIImage *img = [themeManager getThemeImage:self.imgName];
    UIImage *hImg = [themeManager getThemeImage:self.highlightImgName];
    UIImage *backImg = [themeManager getThemeImage:self.backImgName];
    UIImage *backHimg = [themeManager getThemeImage:self.backHighlightImgName];
    
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:hImg forState:UIControlStateHighlighted];
    
    [self setBackgroundImage:backImg forState:UIControlStateNormal];
    [self setBackgroundImage:backHimg forState:UIControlStateHighlighted];
    
    
    //修改标题颜色
    UIColor *titleColor = [themeManager getThemeColor:self.colorKeyName];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

@end
