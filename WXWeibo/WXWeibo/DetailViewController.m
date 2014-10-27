//
//  DetailViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentTableView.h"
#import "WeiboModel.h"
#import "CommentModel.h"

@interface DetailViewController ()<BaseTableViewDelegate>

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博正文";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.weiboModel = self.weiboModel;
    self.tableView.refreshDelegate = self;
    
    [self loadData];
}

//请求评论数据
- (void)loadData {
    NSString *weiboId = [_weiboModel.weiboId stringValue];
    if (weiboId.length == 0) {
        NSLog(@"微博id为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    __block DetailViewController *this = self;
    self.request = [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET"block:^(id result) {
        [this _afterLoadData:result];
    }];
}

- (void)_afterLoadData:(NSDictionary *)result {
    NSArray *array = [result objectForKey:@"comments"];
    
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    
    //刷新表格
    self.tableView.data = comments;
    self.tableView.commentDic = result;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_request disconnect];
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark  BaseTableView delegate
//下拉事件
- (void)pullDown:(BaseTableView *)tableView {
    //请求评论列表接口，参数since_id
    
    //收起下拉
    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3];
}

//上拉事件
- (void)pullUp:(BaseTableView *)tableView {
    //请求下一页评论列表,参数max_id
    
    //恢复上拉
    [tableView performSelector:@selector(setIsMore:) withObject:@YES afterDelay:3];
}

@end
