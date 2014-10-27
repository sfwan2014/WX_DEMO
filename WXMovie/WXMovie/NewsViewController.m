//
//  NewsViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NewsViewController.h"
#import "WXDataService.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"
#import "NewsCell.h"
#import "ImageListViewController.h"
#import "MainTabbarController.h"
#import "NewsDetailViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)dealloc {
    [_data release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"新闻";
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelector:@selector(requestData) withObject:nil afterDelay:2];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main@2x.png"]];
    self.tableView.separatorColor = [UIColor darkGrayColor];

    
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version >= 6.0) {
        //创建下拉刷新控件
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = refreshControl;
        //设置下拉显示的标题
        refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
        [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
        
        [refreshControl release];        
    }
}

- (void)refreshAction:(UIRefreshControl *)refreshControl {
    
    //修改下拉控件的标题
    refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"正在努力加载数据..."] autorelease];
    
    
    //模拟网络请求
    [self performSelector:@selector(requestData) withObject:nil afterDelay:3];
    
}

- (void)requestData {
    
    //下拉刷新请求的数据
    if (self.refreshControl.refreshing) {
        [_data removeAllObjects];
    }
    
    NSArray *array = [WXDataService requestData:news_list];
    for (NSDictionary *dic in array) {
        NewsModel *news = [[NewsModel alloc] initContentWithDic:dic];
//        news.newsId = [dic objectForKey:@"id"];
//        news.newsType = [dic objectForKey:@"type"];
//        news.newsTitle = [dic objectForKey:@"title"];
//        news.newsSummary = [dic objectForKey:@"summary"];
//        news.newsImage = [dic objectForKey:@"image"];
        
        [_data addObject:news];
        [news release];
    }
    
    [self.tableView reloadData];
    
    //数据请求完之后
    self.refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    //停止刷新
    [self.refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //第一个单元格显示大图
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NULL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建大图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        [cell.contentView addSubview:imageView];
        [imageView release];
        
        //创建电影标题Label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.height-30, kScreenWidth, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        titleLabel.font = [UIFont systemFontOfSize:16.0];
        [cell.contentView addSubview:titleLabel];
        
        NewsModel *news = [_data objectAtIndex:indexPath.row];
        //加载图片
        NSString *urlstring = news.newsImage;
        [imageView setImageWithURL:[NSURL URLWithString:urlstring]];
        
        titleLabel.text = news.newsTitle;
        
        return cell;
    }
    
    //新闻列表单元格
    static NSString *identify = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
    }
    
    cell.news = [_data objectAtIndex:indexPath.row];
    
    return cell;
}

//返回单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    }
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsModel *news = [_data objectAtIndex:indexPath.row];
    int type = [news.newsType intValue];
    
    //判断新闻类型
    if (type == 0) {  //普通新闻
        NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
        [self.navigationController pushViewController:newsDetail animated:YES];
        [newsDetail release];
    } else if(type == 1) { //图片新闻
        ImageListViewController *imageCtrl = [[ImageListViewController alloc] init];
        [self.navigationController pushViewController:imageCtrl animated:YES];
        [imageCtrl release];
    } else if(type == 2) { //视频新闻
        NSLog(@"视频新闻，待续...");
    }
}

////视图出现时调用
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    //显示tabbar工具栏
//    [self.tabBarController showTabbar];
//    
//}

@end
