//
//  CommentTableView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentTableView.h"
#import "UserView.h"
#import "WeiboView.h"
#import "WeiboModel.h"
#import "CommentCell.h"

@implementation CommentTableView

- (void)_loadTableHeaderView {
    if (self.tableHeaderView != nil) {
        return;
    }
    
    //1.创建头视图
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    //2.创建用户视图
    _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:nil options:nil] lastObject];
    [_userView retain];
    [tableHeaderView addSubview:_userView];
    //加上子视图的高度
    tableHeaderView.height += _userView.height;
    
    //3.创建微博视图
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isSource:NO isDetail:YES];
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userView.bottom+10, kWeiboView_width_detail, h)];
    _weiboView.isDetail = YES;
    _weiboView.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height += (h+10);
    
    //4.设置tableView的头视图
    self.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
        
        [self _loadTableHeaderView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _userView.weiboModel = self.weiboModel;
    _weiboView.weiboModel = self.weiboModel;
    

}

#pragma mark - UITableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"CommentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        //通过加载xib创建CommentCell对象
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    cell.commentModel = [self.data objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *comment = [self.data objectAtIndex:indexPath.row];
    //计算评论单元格的高度
    float height = [CommentCell getCommentHeight:comment];
    return height + 40;
}

//设置组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//获取组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    sectionHeaderView.backgroundColor = rgb(106, 216, 77, 0.7);
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    countLabel.textColor = [UIColor blueColor];
    
    //评论数量
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    int value = [total intValue];
    countLabel.text = [NSString stringWithFormat:@"评论:%d",value];
    [sectionHeaderView addSubview:countLabel];
    [countLabel release];
    
    return [sectionHeaderView autorelease];
}


@end
