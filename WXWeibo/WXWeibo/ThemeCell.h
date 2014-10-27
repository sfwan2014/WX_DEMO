//
//  ThemeCell.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface ThemeCell : UITableViewCell

@property(nonatomic,retain)ThemeImageView *imgView;
@property(nonatomic,retain)ThemeLabel *txLabel;
@property(nonatomic,retain)ThemeLabel *dtLabel;

@end
