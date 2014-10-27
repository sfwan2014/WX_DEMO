//
//  RectButton.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-12.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (void)dealloc {
    WXRelease(_rectTitleLabel);
    WXRelease(_subTitleLabel);
    WXRelease(_title);
    WXRelease(_subTitle);
    [super dealloc];
}

- (void)setTitle:(NSString *)title {
    if (_title != title) {
        [_title release];
        _title = [title copy];
    }
    
    if (_rectTitleLabel == nil && _title != nil) {
        _rectTitleLabel = [[ThemeLabel alloc] initWithFrame:CGRectZero];
        _rectTitleLabel.backgroundColor = [UIColor clearColor];
        _rectTitleLabel.font = [UIFont systemFontOfSize:18.0f];
        _rectTitleLabel.textColor = [UIColor blackColor];
        _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
        _rectTitleLabel.colorKeyName = @"Profile_BG_Text_color";
        [self addSubview:_rectTitleLabel];
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)setSubTitle:(NSString *)subTitle {
    if (_subTitle != subTitle) {
        [_subTitle release];
        _subTitle = [subTitle copy];
    }
    
    if (_subTitleLabel == nil && _subTitle != nil) {
        _subTitleLabel = [[ThemeLabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:18.0f];
        _subTitleLabel.textColor = [UIColor blueColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.colorKeyName = @"Profile_4Button_Num_color";
        [self addSubview:_subTitleLabel];
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_subTitle != nil) {
        _subTitleLabel.frame = CGRectMake(0, 15, self.width, 20);
        _subTitleLabel.text = _subTitle;
    }
    
    if (_title != nil) {
        _rectTitleLabel.text = _title;
        
        if (_subTitle == nil) {
            float y = (self.height - 20)/2;
            _rectTitleLabel.frame = CGRectMake(0, y, self.width, 20);
        } else {
            _rectTitleLabel.frame = CGRectMake(0, _subTitleLabel.bottom, self.width, 20);
        }
    }
}

@end
