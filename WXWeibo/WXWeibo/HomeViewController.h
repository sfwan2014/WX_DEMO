//
//  HomeViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@class WeiboTableView;
@class ThemeImageView;
@interface HomeViewController : BaseViewController {
    ThemeImageView *_barView;
}

@property(nonatomic,retain)NSMutableArray *data;

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;
@end
