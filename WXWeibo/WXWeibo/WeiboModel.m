//
//  WeiboModel.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboModel.h"

@implementation WeiboModel

- (NSDictionary*)attributeMapDictionary {
    
    NSDictionary *mapAtt = @{
        @"createDate":@"created_at",
        @"weiboId":@"id",
        @"text":@"text",
        @"source":@"source",
        @"favorited":@"favorited",
        @"thumbnailImage":@"thumbnail_pic",
        @"bmiddlelImage":@"bmiddle_pic",
        @"originalImage":@"original_pic",
        @"geo":@"geo",
        @"repostsCount":@"reposts_count",
        @"commentsCount":@"comments_count",
    };
    
    return mapAtt;
}

- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
        [user release];
    }
    
    NSDictionary *retweetDic = [dataDic objectForKey:@"retweeted_status"];
    if (retweetDic != nil) {
        WeiboModel *reWeibo = [[WeiboModel alloc] initWithDataDic:retweetDic];
        self.reWeibo = reWeibo;
        [reWeibo release];
    }
}

@end
