//
//  HomeViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "HomeViewController.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "DetailViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface HomeViewController ()<BaseTableViewDelegate>

@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinishNotification:) name:kLoginNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.refreshDelegate = self;

    //隐藏tableView
    self.tableView.hidden = YES;
    
#warning 修改
/*
    if (self.sinaweibo.isAuthValid) { //判断是否授权

//        [super showLoading:YES];
        [super showHUD:@"正在加载.."];
        
        //请求微博列表数据
        [self _loadWeiboData];
    } else {
        //登陆
        [self.sinaweibo logIn];
    }
*/
    
    
    [super showHUD:@"正在加载.."];
    //请求微博列表数据
    [self _loadWeiboData];

    
    __block HomeViewController *this = self;
    self.tableView.finishBlock = ^{
        //加载新微博
        [this _loadNewWeiboData];
    };
}


//1.视图将要出现，开启左右菜单手势
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //开启左右菜单手势
    MMDrawerController *mmCtrl = self.mm_drawerController;
    [mmCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmCtrl setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

//2.视图将要消失，关闭左右菜单手势
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //关闭左右菜单手势
    MMDrawerController *mmCtrl = self.mm_drawerController;
    [mmCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [mmCtrl setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load Data
//加载微博数据
- (void)_loadWeiboData {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    //网络请求
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:home_timeline
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
    request.tag = 100;
    
}

//加载最新(未读)的微博
- (void)_loadNewWeiboData {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    
    if (self.data.count > 0) {
        WeiboModel *topWeibo = [self.data objectAtIndex:0];
        NSString *topId = [topWeibo.weiboId stringValue];
        
        if (topId.length == 0) {
            return;
        }
        
        /*
         since_id	false	int64	若指定此参数，
         则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
         */
        [params setObject:topId forKey:@"since_id"];
    }
    
    //网络请求
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:home_timeline
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
    request.tag = 101;
}

//请求下一页微博数据
- (void)_loadMoreData {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    
    if (self.data.count > 0) {
        WeiboModel *lastWeibo = [self.data lastObject];
        NSString *lastId = [lastWeibo.weiboId stringValue];
        
        if (lastId.length == 0) {
            return;
        }
        
        /*
         若指定此参数，则返回ID小于或等于max_id的微博，默认为0。         
         */
        [params setObject:lastId forKey:@"max_id"];
    }
    
    //网络请求
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:home_timeline
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
    request.tag = 102;
}

- (void)afterLoadWeiboData:(NSMutableArray *)weibos {
    
    self.tableView.hidden = NO;
//    [super showLoading:NO];
//    [super hideHUD];
    [super hideHUDWithComplete:@"加载完成"];
    
    self.data = weibos;
    //刷新表视图
    self.tableView.data = weibos;
    [self.tableView reloadData];
}

//未读微博加载完成
- (void)afterLoadNewData:(NSMutableArray *)weibos {
    
    //新微博数量
    int count = weibos.count;
    
    if (self.data != nil) {
        [weibos addObjectsFromArray:self.data];
    }
    
    //刷新视图，展示数据
    self.data = weibos;
    self.tableView.data = weibos;
    //1.刷新tableView
    [self.tableView reloadData];
    //2.收起下拉刷新
    [self.tableView doneLoadingTableViewData];
    
    //3.显示新微博的数量
    [self showNewWeiboCount:count];
}

//更多的微博数据加载完成
- (void)afterLoadMoreData:(NSMutableArray *)weibos {
    
    if (weibos.count > 0) {
        [weibos removeObjectAtIndex:0];
    }
    
    [self.data addObjectsFromArray:weibos];
    
    //刷新tableView
    if (weibos.count < 18) {
        self.tableView.isMore = NO;
    } else {
        self.tableView.isMore = YES;
    }
    
    self.tableView.data = self.data;
    [self.tableView reloadData];
}


#pragma mark - BaseTableView delegate
//上拉加载的协议方法
- (void)pullUp:(BaseTableView *)tableView {
    [self _loadMoreData];
}

//选中单元格的协议方法
- (void)didSelectRowAtIndexPath:(BaseTableView *)tabelView indexPath:(NSIndexPath *)indexPath {
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.weiboModel = [self.data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

#pragma mark - SinaWeiboRequest delegate
//数据请求完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSArray *statuses = [result objectForKey:@"statuses"];
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    for (NSDictionary *weiboDic in statuses) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    if (request.tag == 100) {
        [self afterLoadWeiboData:weibos];
    }
    //请求未读的微博
    else if(request.tag == 101) {
        [self afterLoadNewData:weibos];
    }
    else if(request.tag == 102) {
        [self afterLoadMoreData:weibos];
    }
}

//登陆完成
- (void)loginFinishNotification:(NSNotification *)notification {
    [super showHUD:@"正在加载..."];
    
    [self _loadWeiboData];
}

#pragma mark - Views
//显示加载新微博的数量
- (void)showNewWeiboCount:(int)count {
    if (_barView == nil) {
        _barView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
        _barView.imgName = @"timeline_notify.png";
        [self.view addSubview:_barView];
        
        //创建显示数量的Label
        ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:_barView.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.colorKeyName = @"Timeline_Notice_color";
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 2013;
        [_barView addSubview:label];
        [label release];
    }
    
    if (count > 0) {
        ThemeLabel *label = (ThemeLabel *)[_barView viewWithTag:2013];
        label.text = [NSString stringWithFormat:@"%d条新微博",count];
        
        //-----------------1.动画显示---------------------
        [UIView animateWithDuration:0.6 animations:^{
            _barView.top = 5;
        } completion:^(BOOL finished) {
            
            if (finished) {
                [UIView animateWithDuration:0.6 animations:^{
                    //设置收起动画的延迟调用的时间
                    [UIView setAnimationDelay:1];
                    _barView.top = -40;
                }];
            }
            
        }];
        
        //-------------------2.声音提示--------------------
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        //1.将声音文件注册为系统声音
        SystemSoundID soundId;
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        //2.播放系统声音
        AudioServicesPlaySystemSound(soundId);
        
        
        //-----3.隐藏未读微博数---
//        [self.tabBarController ]
//        MainViewController *mainCtrl = (MainViewController *)self.tabBarController;
//        [mainCtrl hiddenBadge];
        
        [self.tabBarController hiddenBadge];
    }
}

@end
