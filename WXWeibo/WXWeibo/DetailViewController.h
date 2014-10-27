//
//  DetailViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@class WeiboModel;
@class CommentTableView;
@interface DetailViewController : BaseViewController

@property(nonatomic,retain)WeiboModel *weiboModel;
@property (retain, nonatomic) IBOutlet CommentTableView *tableView;
@property(nonatomic,retain)SinaWeiboRequest *request;

@end
