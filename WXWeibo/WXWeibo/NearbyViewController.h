//
//  NearbyViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-5-27.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectedDoneBlock)(NSDictionary *result);

@interface NearbyViewController : BaseViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)NSArray *data;

@property(nonatomic,copy)SelectedDoneBlock selectedBlock;

@end
