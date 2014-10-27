//
//  ImageDetailViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "PhotoTableView.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (void)dealloc {
    WXRelease(_data);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    
    PhotoTableView *_tableView = [[PhotoTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20) style:UITableViewStylePlain];
    _tableView.rowHeight = kScreenWidth;
    [self.view addSubview:_tableView];
    
    //将所有的图片url赋给tableView显示
    _tableView.data = self.data;
    
    //滚动到指定的单元格
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
