//
//  TopViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "TopViewController.h"
#import "MovieModel.h"
#import "TopCell.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"TOP 250";
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建tableView
    [self loadTableView];
    
    //显示正在加载
    [super showHUD:@"正在加载..."];
    
    //请求数据
    [self performSelector:@selector(requesData) withObject:nil afterDelay:2];
}

//创建tableView
- (void)loadTableView {
    _topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44-49) style:UITableViewStylePlain];
    _topTableView.delegate = self;
    _topTableView.dataSource = self;
    _topTableView.rowHeight = 150;
    _topTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main@2x.png"]];
    //隐藏垂直水平滚动条
    _topTableView.showsVerticalScrollIndicator = NO;
    //去掉分割线
    _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_topTableView];
}

- (void)requesData {
    //隐藏加载
    [super hideHUD];
    
    NSDictionary *jsonData = [WXDataService requestData:top250];
    NSArray *array = [jsonData objectForKey:@"subjects"];
    
    /*
      整理数据的结构
      [
        [Movie1,Movie2,Movie3],
        [Movie1,Movie2,Movie3],
        [Movie1,Movie2],
      ]
     */
    if (array.count > 0) {
        
        //取得最后一个小数组
        NSMutableArray *cellArray = [_data lastObject];
        
        for (int i=0; i<array.count; i++) {
            //判断此数组的个数是否填满，是的话创建下一个新的数组
            if (cellArray.count == 3 || cellArray == nil) {
                cellArray = [NSMutableArray arrayWithCapacity:3];
                [_data addObject:cellArray];
            }
            
            NSDictionary *dic = array[i];
            MovieModel *movieModel = [[MovieModel alloc] initContentWithDic:dic];
            [cellArray addObject:movieModel];
            [movieModel release];
        }
    }
    
    //刷新tableView
    [_topTableView reloadData];
}

#pragma mark - UITableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"topCell";
    
    TopCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[TopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    cell.data = _data[indexPath.row];
    
    return cell;
    
}


@end
