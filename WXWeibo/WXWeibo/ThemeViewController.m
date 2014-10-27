//
//  ThemeViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-5.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"主题选择";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    NSDictionary *themeDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    _themeData = [[themeDic allKeys] retain];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"kIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSString *themeName = [_themeData objectAtIndex:indexPath.row];
    cell.textLabel.text = themeName;
    
    //当前显示的主题
    NSString *currentThemeName = [ThemeManager shareInstance].themeName;
    if ([themeName isEqualToString:currentThemeName]) {
        //单元格中显示的主题打钩
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1.获取到当前主题
    NSString *themeName = [_themeData objectAtIndex:indexPath.row];
    
    //2.修改当前主题
    [ThemeManager shareInstance].themeName = themeName;
    
    //3.发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNofitication object:nil];
    
    //4.保存选中的主题
    [[ThemeManager shareInstance] saveTheme];
    
    //5.刷新列表
    [tableView reloadData];
}

@end
