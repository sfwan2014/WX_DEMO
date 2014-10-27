//
//  BaseCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseCell.h"
#import "ThemeManager.h"

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNofitication object:nil];
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self themeChangeAction];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    [self themeChangeAction];
    
}

- (void)setBackgroundColorKeyName:(NSString *)backgroundColorKeyName {
    if (_backgroundColorKeyName != backgroundColorKeyName) {
        [_backgroundColorKeyName release];
        _backgroundColorKeyName = [backgroundColorKeyName copy];
        
        [self themeChangeAction];
    }
}

- (void)setSelectedColorKeyName:(NSString *)selectedColorKeyName {
    if (_selectedColorKeyName != selectedColorKeyName) {
        [_selectedColorKeyName release];
        _selectedColorKeyName = [selectedColorKeyName copy];
        
        [self themeChangeAction];
    }
}

- (void)themeChangeAction {
    if (self.backgroundView == nil) {
        self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    self.backgroundView.backgroundColor = [[ThemeManager shareInstance] getThemeColor:self.backgroundColorKeyName];
    
//    if (self.selectedBackgroundView == nil) {
//        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//        self.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
//    }    
//    self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
//    UIColor *bgColor = [[ThemeManager shareInstance] getThemeColor:self.selectedColorKeyName];
//    self.selectedBackgroundView.backgroundColor = bgColor;
}

- (UILabel *)textLabel {
    UILabel *label = [super textLabel];
    if (label.superview == nil) {
        [self.contentView addSubview:label];
    }
    
    return label;
}

- (UILabel *)detailTextLabel {
    UILabel *label = [super detailTextLabel];
    if (label.superview == nil) {
        [self.contentView addSubview:label];
    }
    
    return label;
}

//- (UIImageView *)imageView {
//    UIImageView *img = [super imageView];
//    if (img.superview == nil) {
//        [self.contentView addSubview:img];
//    }
//    
//    return img;
//}

@end
