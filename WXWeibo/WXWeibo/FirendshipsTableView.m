//
//  FirendshipsTableView.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "FirendshipsTableView.h"
#import "FriendshipsCell.h"

@implementation FirendshipsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //去掉分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"UserCell";
    FriendshipsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[FriendshipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    
    cell.userData = [self.data objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

@end
