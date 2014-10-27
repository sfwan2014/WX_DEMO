//
//  ProfileViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserModel.h"
#import "WeiboTableView.h"
#import "UserMetaView.h"
#import "WeiboModel.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人中心";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _requests = [[NSMutableArray alloc] init];
    
    if (self.isLoginUser) {
        //如果是登录用户，取得登录用户的id
        self.userId = self.sinaweibo.userID;
    }
    
    //1.显示加载提示
    self.tableView.hidden = YES;
    [super showHUD:@"正在加载"];
    
    //2.加载用户资料数据
    [self _loadUserData];
    
    //3.加载微博列表数据
    [self _loadWeiboData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //取消请求
    for (SinaWeiboRequest *request in _requests) {
        [request disconnect];
    }
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

#pragma mark - load data
//1.加载用户数据
- (void)_loadUserData {
    if (self.userId.length == 0 && self.nickName.length == 0) {
        WXLog(@"error:用户为空!");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    if (self.userId.length != 0) {
        [params setObject:self.userId forKey:@"uid"];
    }
    else if(self.nickName.length != 0) {
        [params setObject:self.nickName forKey:@"screen_name"];
    }
    
//    [self.sinaweibo requestWithURL:<#(NSString *)#> params:<#(NSMutableDictionary *)#> httpMethod:<#(NSString *)#> delegate:<#(id<SinaWeiboRequestDelegate>)#>];
    
    __block ProfileViewController *this = self;
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:users_profile
                            params:params httpMethod:@"GET" block:^(id result) {

            [this _afterLoadUserData:result];
    }];
    
    [_requests addObject:request];
    
}

//2.加载用户的微博数据
- (void)_loadWeiboData {
    if (self.userId.length == 0 && self.nickName.length == 0) {
        WXLog(@"error:用户为空!");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    if (self.userId.length != 0) {
        [params setObject:self.userId forKey:@"uid"];
    }
    else if(self.nickName.length != 0) {
        [params setObject:self.nickName forKey:@"screen_name"];
    }
    
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:user_timeline params:params httpMethod:@"GET" block:^(id result) {
        [self _afterLoadWeiboData:result];
    }];
    
    [_requests addObject:request];
    
}

- (void)_afterLoadUserData:(id)result {
    UserModel *user = [[UserModel alloc] initWithDataDic:result];
    
    //1.隐藏加载提示
    [super hideHUD];
    self.tableView.hidden = NO;
    
    //2.刷新view
    [self _refreshUserView:user];
    
    [user release];
}

- (void)_afterLoadWeiboData:(id)result {
    NSArray *statuses = [result objectForKey:@"statuses"];
    
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    for (NSDictionary *dic in statuses) {
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        [weibos addObject:weiboModel];
        [weiboModel release];
    }

    //刷新视图
    self.tableView.data = weibos;
    [self.tableView reloadData];
}

#pragma mark - load View
- (void)_refreshUserView:(UserModel *)user {
    if (_userView == nil) {
        //加载xib创建UserMetaView 视图
        _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserMetaView" owner:nil options:nil] lastObject];
        [_userView retain];
        self.tableView.tableHeaderView = _userView;
    }
    _userView.user = user;
}

@end
