//
//  ThemeViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate> {
    NSArray *_themeData;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@end
