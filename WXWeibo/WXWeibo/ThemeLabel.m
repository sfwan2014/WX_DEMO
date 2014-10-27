//
//  ThemeLabel.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

- (void)dealloc {
    [super dealloc];
    self.colorKeyName = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeDidChangeNofitication object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeDidChangeNofitication object:nil];    
}

- (void)themeChangeAction:(NSNotification *)notification {
    [self loadColor];
}

- (void)setColorKeyName:(NSString *)colorKeyName {
    if (colorKeyName != _colorKeyName) {
        [_colorKeyName release];
        _colorKeyName = [colorKeyName copy];
        
        [self loadColor];
    }
}

- (void)loadColor {
    UIColor *fontColor = [[ThemeManager shareInstance] getThemeColor:self.colorKeyName];
    self.textColor = fontColor;
}


@end
