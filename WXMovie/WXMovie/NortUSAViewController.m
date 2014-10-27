//
//  NortUSAViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NortUSAViewController.h"
#import "WXDataService.h"
#import "MovieModel.h"
#import "USMovieCell.h"
#import "PosterView.h"

@interface NortUSAViewController ()

@end

@implementation NortUSAViewController

- (void)dealloc {
    [_dataArr release];
    [_tableView release];
    [_posterView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"北美榜";
        _dataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.初始化导航栏上的按钮
    [self _loadNaviagaitonItem];
    
    //2.初始化列表视图
    [self _loadTableView];
    
    //3.创建海报视图
    [self _loadPosterView];
    
    [super showHUD:@"正在加载..."];
    //模拟请求网络数据，1.5秒之后请求下来数据
    [self performSelector:@selector(requestData) withObject:nil afterDelay:2];

}

//请求数据
- (void)requestData {
    [super hideHUD];
    
    NSDictionary *jsonData = [WXDataService requestData:usbox_json];
    NSArray *array = [jsonData objectForKey:@"subjects"];
    for (NSDictionary *dic in array) {
        NSDictionary *subject = [dic objectForKey:@"subject"];
        
        //将字典中的数据取出填充至model对象上
        MovieModel *movie = [[MovieModel alloc] init];
        movie.rating = [subject objectForKey:@"rating"];
        movie.collect_count = [subject objectForKey:@"collect_count"];
        movie.images = [subject objectForKey:@"images"];
        movie.usId = [subject objectForKey:@"id"];
        movie.title = [subject objectForKey:@"title"];
        movie.year = [subject objectForKey:@"year"];
        movie.original_title = [subject objectForKey:@"original_title"];
        
        [_dataArr addObject:movie];
        
        [movie release];
    }
    
    //刷新表视图，重新读取数据
    [_tableView reloadData];
    
    
    [_posterView setData:_dataArr];
//    _posterView.data = _dataArr;
    
}

//*_________________________初始化UI视图____________________________________*/

#pragma mark - init UI  初始化UI视图
//初始化导航栏上的按钮
- (void)_loadNaviagaitonItem {
    
    //1.创建翻转按钮的父视图
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    //2.创建右侧两个翻转按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.hidden = YES;
    button1.tag = 200;
    button1.frame = buttonView.bounds;
    [button1 setImage:[UIImage imageNamed:@"poster_home.png"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"exchange_bg_home@2x.png"]
                       forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(rightBarItemClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button1];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = buttonView.bounds;
    button2.hidden = NO;
    button2.tag = 201; 
    [button2 setImage:[UIImage imageNamed:@"list_home.png"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"exchange_bg_home@2x.png"]
                       forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(rightBarItemClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:button2];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    [buttonView release];
    
}

//创建表视图
- (void)_loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44-49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main@2x.png"]];
    _tableView.separatorColor = [UIColor darkGrayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.rowHeight = 120;
    [self.view addSubview:_tableView];
}

//创建海报视图
- (void)_loadPosterView {
    _posterView = [[PosterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44-49)];
    _posterView.hidden = NO;
    [self.view addSubview:_posterView];
    
}

#pragma mark - actions 事件方法
//翻转按钮的点击方法
- (void)rightBarItemClickAction:(UIButton *)button {
    
    //翻转按钮的父视图
    UIView *buttonView = self.navigationItem.rightBarButtonItem.customView;
    
    //禁用button点击,防止按钮快速点击
    buttonView.userInteractionEnabled = NO;
    
    //按钮的隐藏状态取反
    UIView *button1 = [buttonView viewWithTag:200];
    UIView *button2 = [buttonView viewWithTag:201];
    
    button1.hidden = !button1.hidden;
    button2.hidden = !button2.hidden;

    [self flipViewAction:buttonView left:button1.hidden];
    
    //海报--表视图 翻转
    _tableView.hidden = !_tableView.hidden;
    _posterView.hidden = !_posterView.hidden;
    [self flipViewAction:self.view left:button1.hidden];
    
    //开启按钮的点击
    [buttonView performSelector:@selector(setUserInteractionEnabled:) withObject:@YES afterDelay:0.5];
}

/*
  方法描述：翻转两个视图
  参数：
   forView ： 需要添加翻转动画的视图
   left    ： 是否从左边翻转
 */
- (void)flipViewAction:(UIView *)forView left:(BOOL)flag {
    
    //判断翻转方向
    UIViewAnimationTransition transition = flag ? UIViewAnimationTransitionFlipFromLeft:UIViewAnimationTransitionFlipFromRight;
    
    //给翻转按钮的父视图添加翻转动画效果
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:transition forView:forView cache:YES];
    [UIView commitAnimations];
    
    //调换两个子视图的位置
    [forView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"movieCell";
    
    USMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[USMovieCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
    }
    
    cell.movieModel = [_dataArr objectAtIndex:indexPath.row];
    
    return cell;
}

@end
