//
//  MoreViewController.h
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MoreViewController : BaseViewController {
    UITableView *_tableView;
    
    NSArray *_data;
    NSArray *_images;
    
    //记录缓存大小
    long long sum;
}

@end
