//
//  USBoxMovie.m
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

- (void)dealloc {
//    [_rating release];
    self.rating = nil;   //等价于[self setRating:nil]  --> [_rating release]; _rating = nil;
    self.collect_count = nil;
    self.images = nil;
    [super dealloc];
}

- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];

    self.usId = [jsonDic objectForKey:@"id"];
}

@end
