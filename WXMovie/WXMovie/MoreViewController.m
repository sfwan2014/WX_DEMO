//
//  MoreViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MoreViewController.h"
#import "WXSegment.h"
#import "SDImageCache.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = self.view.backgroundColor;
    /*
      UITableViewStyleGrouped类型的背景去掉，设置tableView.backgroundView = nil;
     */
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor grayColor];
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MoreList" ofType:@"plist"];
    _data = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    _images = @[@"moreClear.png",@"moreScore.png",@"moreBusiness.png",@"moreVersion.png",@"moreWelcome.png",@"moreAbout.png"];
    [_images retain];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self countCacheSize];
    
    //刷新显示重新计算的缓存大小
    [_tableView reloadData];
}

//计算缓存大小
- (void)countCacheSize {
    sum = 0;
    
    //图片缓存的目录路径
    NSString *imageDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    sum = [UIUtils countDirectorySize:imageDirectory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *identify = @"moreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify] autorelease];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSString *imageName = _images[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    cell.textLabel.text = _data[indexPath.row];
    
    if (indexPath.row == 0) {
        float s = sum / (1024*1024.0);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1fM",s];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) { //清除缓存

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"清空缓存" message:@"确定要清空缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
    }
    
    //重新计算缓存大小
    [self countCacheSize];
    [_tableView reloadData];
    
}

@end
