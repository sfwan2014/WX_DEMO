//
//  ThemeCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeCell.h"
#import "ThemeManager.h"

@implementation ThemeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNofitication object:nil];
        
        [self themeChangeAction];
    }
    return self;
}

- (void)_initViews {
    _imgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
    _txLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(_imgView.right+5, 11, 200, 20)];
    _dtLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(180, 11, 95, 20)];
        
    _txLabel.font = [UIFont boldSystemFontOfSize:16];
    _txLabel.backgroundColor = [UIColor clearColor];
    _txLabel.colorKeyName = @"More_Item_Text_color";
    
    _dtLabel.font = [UIFont systemFontOfSize:15];
    _dtLabel.textAlignment = NSTextAlignmentRight;
    _dtLabel.backgroundColor = [UIColor clearColor];
    _dtLabel.colorKeyName = @"More_Item_Text_color";
    
    [self.contentView addSubview:_imgView];
    [self.contentView addSubview:_txLabel];
    [self.contentView addSubview:_dtLabel];
}

- (void)themeChangeAction {
    self.backgroundColor = [[ThemeManager shareInstance] getThemeColor:@"More_Item_color"];
}

@end
