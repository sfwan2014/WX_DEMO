//
//  CommentModel.m
//  WXMovie
//
//  Created by wei.chen on 13-9-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (void)dealloc
{
    self.userImage = nil;
    self.nickname = nil;
    self.rating = nil;
    self.content = nil;
    [super dealloc];
}

@end
