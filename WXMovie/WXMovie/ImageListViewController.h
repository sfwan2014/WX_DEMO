//
//  ImageListViewController.h
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ImageListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_data;
    UITableView *_tableView;
}

@property(nonatomic,retain)NSMutableArray *imageArray;

@end
