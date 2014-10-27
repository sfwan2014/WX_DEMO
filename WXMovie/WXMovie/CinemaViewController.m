//
//  CinemaViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CinemaViewController.h"
#import "CinemaModel.h"
#import "CinemaCell.h"
#import "CinemaDetailViewController.h"

@interface CinemaViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CinemaViewController {
    UITableView *_tableView;
}

- (void)dealloc {
    [_tableView release];
    [cinemaData release];
    [districtArray release];
    [_refreshView release];    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"电影院";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cinemaData = [[NSMutableDictionary alloc] init];
    
    //创建导航栏按钮
    [self _loadButtonItem];
    
    //创建影院列表视图
    [self _loadTableView];
    
    _tableView.hidden = YES;
    [super showHUD:@"正在加载..."];
    [self performSelector:@selector(_loadRequestData) withObject:nil afterDelay:2];
}


/*
 ios6.0之前调用的卸载视图方法，
 此方法调用的条件:
    1.内存警告
    2.当前控制器视图没有在window中显示
    3.覆写loadView方法
 */
- (void)viewDidUnload {
    [super viewDidUnload];
    
    WXRelease(_tableView);
    WXRelease(cinemaData);
    WXRelease(districtArray);
    WXRelease(_refreshView);
}

#pragma mark - Load Data

- (void)_loadRequestData {
    [super hideHUD];
    
    //下拉刷新时，清空上次的数据
    if (cinemaData.count > 0) {
        [cinemaData removeAllObjects];
    }
    
    //获取到所有的影院列表
    NSDictionary *jsonData = [WXDataService requestData:cinema_list];
    NSArray *cinemaList = [jsonData objectForKey:@"cinemaList"];
    
    //整理影院列表数据
    //结构
    /*
     {
        "区id 1001":[影院model,...],
        "区id 1002':[影院model,...],
        ...
     }
     */
    for (NSDictionary *cinemaDic in cinemaList) {
        CinemaModel *cm = [[CinemaModel alloc] initContentWithDic:cinemaDic];
        
        //此影院所在的区的ID
        NSString *districtId =  cm.districtId;
        
        //通过区ID，取得对应的影院列表
        NSMutableArray *cinemas = [cinemaData objectForKey:districtId];
        if (cinemas == nil) {
            //如果影院列表为空，则为区ID创建一个新的数组
            cinemas = [NSMutableArray array];
            [cinemaData setObject:cinemas forKey:districtId];
        }
        
        [cinemas addObject:cm];
        
        [cm release];
    }
    
    
    //读取区列表数据
    NSDictionary *distrcitDic = [WXDataService requestData:district_list];
    districtArray = [[distrcitDic objectForKey:@"districtList"] retain];
    
    //刷新表视图
    _tableView.hidden = NO;
    [_tableView reloadData];
    
    //收起下拉
    [self doneLoadingTableViewData];
}

#pragma mark - Load UI
//创建导航栏按钮
- (void)_loadButtonItem {
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"movieLocationIcon@2x.png"]
                              forState:UIControlStateNormal];
    locationButton.frame = CGRectMake(0, 0, 20, 24);
    [locationButton addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:locationButton];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}

- (void)_loadTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.separatorColor = [UIColor darkGrayColor];
    [self.view addSubview:_tableView];
    
    //创建下拉控件
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
    _refreshView.delegate = self;
    _refreshView.backgroundColor = [UIColor clearColor];
    [_tableView addSubview:_refreshView];
}

#pragma mark - UITableView dataSource
//设置组的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return districtArray.count;
}

//设置每个组里面单元格的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //是否收起
    BOOL isClose = close[section];
    if (isClose) {
        return 0;
    }
    
    
    //获取区的字典
    NSDictionary *districtDic = [districtArray objectAtIndex:section];
    //区的ID
    NSString *districtId = [districtDic objectForKey:@"id"];
    
    //影院列表
    NSArray *cinemaList = [cinemaData objectForKey:districtId];
    
    return cinemaList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *identify = @"cinemaCell";
    
    CinemaCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[CinemaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify] autorelease];
    }
    
    //获取区的字典
    NSDictionary *districtDic = [districtArray objectAtIndex:indexPath.section];
    //区的ID
    NSString *districtId = [districtDic objectForKey:@"id"];
    
    //影院列表
    NSArray *cinemaList = [cinemaData objectForKey:districtId];
    CinemaModel *cm = [cinemaList objectAtIndex:indexPath.row];
    
    cell.cinemaModel = cm;
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSDictionary *districtDic = [districtArray objectAtIndex:section];
//    NSString *name = [districtDic objectForKey:@"name"];
//    return name;
//}

//返回组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *districtDic = [districtArray objectAtIndex:section];
    NSString *name = [districtDic objectForKey:@"name"];
    
    UIControl *titleView = [[UIControl alloc] initWithFrame:CGRectZero];
    titleView.tag = section;
    titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hotMovieBottomImage@2x.png"]];
    [titleView addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 0, 0)];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = name;
    [textLabel sizeToFit];
    
    [titleView addSubview:textLabel];
    [textLabel release];
    
    return [titleView autorelease];
}

//设置组的头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

//选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取区的字典
    NSDictionary *districtDic = [districtArray objectAtIndex:indexPath.section];
    //区的ID
    NSString *districtId = [districtDic objectForKey:@"id"];
    
    //影院列表
    NSArray *cinemaList = [cinemaData objectForKey:districtId];
    CinemaModel *cm = [cinemaList objectAtIndex:indexPath.row];
    
    
    CinemaDetailViewController *cinemaDetail = [[CinemaDetailViewController alloc] init];
    //传递影院的ID
    cinemaDetail.cinemaId = cm.cinemaId;
    [self.navigationController pushViewController:cinemaDetail animated:YES];
    [cinemaDetail release];
}

#pragma mark - actions
- (void)sectionAction:(UIControl *)control {
    //组的索引
    int section = control.tag;
    
    close[section] = !close[section];
    
    //刷新组
//    [_tableView reloadData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

- (void)locationAction:(UIButton *)button {
    NSLog(@"显示影院地图");
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定的距离，手指放开后，调用的方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
//    _reloading = YES;
    
    //请求网络数据
    [self performSelector:@selector(_loadRequestData) withObject:nil afterDelay:2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
