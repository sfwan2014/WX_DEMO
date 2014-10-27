//
//  UserView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIUtils.h"
#import "UserHeaderView.h"

@implementation UserView

- (void)dealloc {
    [_userImageView release];
    [_nickLabel release];
    [_createLabel release];
    [_sourceLabel release];
    [super dealloc];
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *imageUrl = self.weiboModel.user.avatar_large;
    [self.userImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.userImageView.user = self.weiboModel.user;
    
    self.nickLabel.text = self.weiboModel.user.screen_name;
    
    NSString *createDate = [self.weiboModel createDate];
    //1.将字符串格式化为日期对象
    NSDate *date = [UIUtils dateFromString:createDate formate:@"E M d HH:mm:ss Z yyyy"];
    //2.将日期对象格式化为目标字符串
    NSString *datestring = [UIUtils stringFromDate:date formate:@"MM-dd HH:mm"];
    self.createLabel.text = datestring;
    
    NSString *result = [UIUtils parseSourceText:self.weiboModel.source];
    self.sourceLabel.text = result;
}
@end
