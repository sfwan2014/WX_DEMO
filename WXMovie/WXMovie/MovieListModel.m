//
//  MovieListModel.m
//  WXMovie
//
//  Created by wei.chen on 13-9-9.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MovieListModel.h"

@implementation MovieListModel

- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];
    
    self.movieId = [jsonDic objectForKey:@"id"];
}

@end
