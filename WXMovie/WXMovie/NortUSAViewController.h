//
//  NortUSAViewController.h
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class PosterView;
@interface NortUSAViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate> {
    UITableView *_tableView;
    PosterView *_posterView;
    
    NSMutableArray *_dataArr;
}

@end
