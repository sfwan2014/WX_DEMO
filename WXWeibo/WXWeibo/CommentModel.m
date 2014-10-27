//
//  CommentModel.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
    self.user = user;
    [user release];
    
    NSDictionary *status = [dataDic objectForKey:@"status"];
    WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:status];
    self.weibo = weibo;
    [weibo release];
    
    NSDictionary *commentDic = [dataDic objectForKey:@"reply_comment"];
    if (commentDic != nil) {
        CommentModel *sourceComment = [[CommentModel alloc] initWithDataDic:commentDic];
        self.sourceComment = sourceComment;
        [sourceComment release];        
    }
}

@end
