//
//  BaseCell.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

//选中的背景颜色
@property(nonatomic,copy)NSString *selectedColorKeyName;
//正常状态下的背景颜色
@property(nonatomic,copy)NSString *backgroundColorKeyName;


@end
