//
//  ThemeImageView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

- (void)dealloc {
    [super dealloc];
    self.imgName = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofitication object:nil];
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

- (void)setImgName:(NSString *)imgName {
    if (_imgName != imgName) {
        [_imgName release];
        _imgName = [imgName copy];
        
        [self loadImage];
    }
    
}

- (void)themeChangeAction:(NSNotification *)notification {
    [self loadImage];
}

- (void)loadImage {
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:self.imgName];
    
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    
    self.image = image;
}

@end
