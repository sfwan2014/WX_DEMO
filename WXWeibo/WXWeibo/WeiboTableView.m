//
//  WeiboTableView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboView.h"

@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNotification object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNotification object:nil];
    
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
}

#pragma mark - UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"weiboCell";
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    cell.weiboModel = self.data[indexPath.row];
    
    return cell;
}

//指定微博单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    WeiboModel *weiboModel = self.data[indexPath.row];
    //计算微博视图的高度
    float h = [WeiboView getWeiboViewHeight:weiboModel isSource:NO isDetail:NO];
    
    return (h+60);
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}


@end
