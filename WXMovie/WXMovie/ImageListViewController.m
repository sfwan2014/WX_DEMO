//
//  ImageListViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ImageListViewController.h"
#import "WXDataService.h"
#import "ImageModel.h"
#import "ImageCell.h"

@interface ImageListViewController ()

@end

@implementation ImageListViewController

- (void)dealloc {
    [_tableView release];
    [_data release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"厨子戏子痞子";
        self.imageArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 75;
    [self.view addSubview:_tableView];
    
    [self requeData];
    
}

- (void)requeData {
    
     NSArray *array = [WXDataService requestData:image_list];
    
    //整理数组
    /*
      [
        [{},{},{},{}],
        [{},{},{},{}]     
      ]
     */
    _data = [[NSMutableArray alloc] init];
    
    NSMutableArray *array2D = nil;
    for (int i=0; i<array.count; i++) {
        //每隔4次满足此条件一次
        if (i % 4 == 0) {   //i 满足的条件 : 0、4、8、12
            array2D = [NSMutableArray array];
            [_data addObject:array2D];
        }
        
        NSDictionary *itemDic = [array objectAtIndex:i];
        //将字典数据填充到model上
        ImageModel *imageModel = [[ImageModel alloc] initContentWithDic:itemDic];
        
        [array2D addObject:imageModel];
        
        [imageModel release];
        
        
        [self.imageArray addObject:imageModel];
    }
    
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
    
    static NSString *identify = @"ImageCell";
    
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    cell.data = [_data objectAtIndex:indexPath.row];
    
    return cell;
}

////视图出现时
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    //隐藏tabbar工具栏
//    [self.tabBarController hideTabbar];    
//}

@end
