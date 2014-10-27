//
//  MessageViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MessageViewController.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setHidden:YES];
    [super showLoading:YES];
    [self loadAtWeiboData];
    
}

- (void)loadAtWeiboData {
    __block MessageViewController *this = self;
    [WXDataService requestWithURL:@"statuses/mentions.json" params:nil httpMethod:@"GET" block:^(id result) {        
        [this loadAtWeiboDataFinish:result];
    }];
}

- (void)loadAtWeiboDataFinish:(NSDictionary *)result {
    NSArray *statues = [result objectForKey:@"statuses"];
    
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    for (NSDictionary *weiboDic in statues) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboDic];
        //        [weibo setAttributes:weiboDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    self.tableView.data = weibos;
    [self.tableView setHidden:NO];
    [super showLoading:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

@end
