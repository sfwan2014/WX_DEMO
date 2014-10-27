//
//  FriendshipsViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "FriendshipsViewController.h"
#import "UserModel.h"

@interface FriendshipsViewController ()
//下一页的游标值
@property(nonatomic,copy)NSString *nextCursor;

@end

@implementation FriendshipsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载提示
    self.tableView.hidden = YES;
    self.tableView.refreshDelegate = self;
    [super showLoading:YES];
    //去掉分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //关注列表
    if (self.shipType == Attention) {
        self.title = @"关注列表";
        [self loadData:URL_FRIENDS];
    }
    else if(self.shipType == Fans) {
        self.title = @"粉丝列表";
        [self loadData:URL_FOLOWERS];
    }
}

- (void)loadData:(NSString *)urlstring {
    if (self.userId.length == 0) {
        NSLog(@"用户id为空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userId forKey:@"uid"];
    
    //返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0
    if (self.nextCursor.length > 0) {
        [params setObject:self.nextCursor forKey:@"cursor"];
    }
        
    /**
     * 1.block访问了局部对象,会将此对象retain
       2.block访问了全局的方法、或者全局变量，会将当前对象retain
     */    
    [self.sinaweibo requestWithURL:urlstring
                            params:params httpMethod:@"GET" block:^(id result) {
                                [self afterLoadData:result];
                            }];
}

//数据请求之后的处理
- (void)afterLoadData:(id)result {
    //记录下一页的游标值
    self.nextCursor = [[result objectForKey:@"next_cursor"] stringValue];
    
    /**
     * [
     ["用户1","用户2","用户3"],
     ["用户4","用户5"]
     ]
     */
    NSArray *usersArray = [result objectForKey:@"users"];
    
    NSMutableArray *array2D = nil;
    for (int i=0;i<usersArray.count;i++) {
        //        if (i % 3 == 0) {
        //            array2D = [NSMutableArray arrayWithCapacity:3];
        //            [_data addObject:array2D];
        //        }
        
        //取出最后一个小数组
        array2D = [_data lastObject];
        //判断此数组是否填满(3个)，如果填满3个，则创建下一个数组
        if (array2D.count == 3 || array2D == nil) {
            array2D = [NSMutableArray arrayWithCapacity:3];
            [_data addObject:array2D];
        }
        
        NSDictionary *userDic = [usersArray objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];
        [array2D addObject:userModel];
        [userModel release];
    }
    
    //----------------------------刷新UI----------------------
    /*
      {
        "id":"model"
        "1001":"model"
      }
     */
    if (usersArray.count >= 40) {
        self.tableView.isMore = YES;
    } else {
        self.tableView.isMore = NO;
    }
    self.tableView.data = _data;
    self.tableView.hidden = NO;
    [super showLoading:NO];
    [self.tableView reloadData];
    
    //收起下拉
    [self.tableView doneLoadingTableViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeiboRequest delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    [self afterLoadData:result];
}

#pragma mark - BaseTableView delegate
//下拉事件
- (void)pullDown:(BaseTableView *)tableView {
    //清空数组
    [_data removeAllObjects];
    //将下一页游标设置空
    self.nextCursor = nil;
    
    if (self.shipType == Attention) {
        [self loadData:URL_FRIENDS];
    }
    else if(self.shipType == Fans) {
        [self loadData:URL_FOLOWERS];
    }
}

//上拉事件
- (void)pullUp:(BaseTableView *)tableView {
    if (self.shipType == Attention) {
        [self loadData:URL_FRIENDS];
    }
    else if(self.shipType == Fans) {
        [self loadData:URL_FOLOWERS];
    }
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

@end
