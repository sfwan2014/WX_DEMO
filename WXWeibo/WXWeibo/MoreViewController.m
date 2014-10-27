//
//  MoreViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "ThemeCell.h"
#import "ThemeManager.h"
#import "BrowModeViewController.h"
#import "LoginViewController.h"

@interface MoreViewController ()

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
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *identify = @"kIdentifier";
    
    ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[ThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.txLabel.text = @"主题选择";
            cell.imgView.imgName = @"more_icon_theme.png";
            cell.dtLabel.text = [ThemeManager shareInstance].themeName;
        }
        else if(indexPath.row ==1) {
            cell.txLabel.text = @"账号管理";
            cell.imgView.imgName = @"more_icon_account.png";
        }
        else if(indexPath.row == 2) {
            cell.txLabel.text = @"图片浏览模式";
            cell.imgView.imgName = @"more_icon_draft.png";
        }
    }
    else if(indexPath.section == 1) {
        cell.txLabel.text = @"意见反馈";
        cell.imgView.imgName = @"more_icon_feedback.png";
        
    }
    else if(indexPath.section == 2) {
        cell.txLabel.text = @"注销当前账号";
        cell.txLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (indexPath.section < 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //切换到主题选择
        ThemeViewController *themeCtrl = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:themeCtrl animated:YES];
        [themeCtrl release];
    } else if(indexPath.section == 2 && indexPath.row == 0) {
//        [self.sinaweibo logOut];
        
        //1.删除认证信息
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        //2.进入登陆界面
        LoginViewController *loginCtrl = [[LoginViewController alloc] init];
        self.view.window.rootViewController = loginCtrl;
        
    }
    else if(indexPath.row == 2 && indexPath.section == 0) {
        BrowModeViewController *brow = [[BrowModeViewController alloc] init];
        [self.navigationController pushViewController:brow animated:YES];
        [brow release];
    }
    
    //取消选择单元格
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
