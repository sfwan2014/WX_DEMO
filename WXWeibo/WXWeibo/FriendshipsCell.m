//
//  FriendshipsCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "FriendshipsCell.h"
#import "UserGridView.h"
#import "UserModel.h"

@implementation FriendshipsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)_initViews {
    for(int i=0;i<3;i++) {
        UserGridView *gridView = [[[NSBundle mainBundle] loadNibNamed:@"UserGridView" owner:nil options:nil] lastObject];
        gridView.tag = 2013+i;
        [self.contentView addSubview:gridView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
        
    //遍历用户数据，有几个用户就显示几个用户视图
    for(int i=0;i<3;i++) {
        int tag = 2013+i;
        UserGridView *gridView = (UserGridView *)[self.contentView viewWithTag:tag];
        
        if (i < _userData.count) {
            gridView.frame = CGRectMake(100*i+12, 10, 96, 96);
            gridView.hidden = NO;
            
            UserModel *userModel = [_userData objectAtIndex:i];
            gridView.user = userModel;
        } else {
            gridView.hidden = YES;
        }
    }
}

@end
