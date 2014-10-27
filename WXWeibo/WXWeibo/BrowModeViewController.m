//
//  BrowModeViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BrowModeViewController.h"

@interface BrowModeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BrowModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"图片浏览模式";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"kIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"大图浏览";
    } else if(indexPath.row == 1) {
        cell.textLabel.text = @"小图浏览";
    } else if(indexPath.row == 2) {
        cell.textLabel.text = @"无图浏览";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.选择模式
    int mode = kSmalModel;
    if (indexPath.row == 0) {
        mode = kLargeModel;
    } else if(indexPath.row == 1) {
        mode = kSmalModel;
    } else if(indexPath.row == 2) {
        mode = kNoneModel;
    }
    
    //2.将浏览模式保存本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //3.发送刷新微博列表的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
}

@end
