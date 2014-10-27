//
//  NewsModel.m
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)dealloc {
    [_newsId release];
    [_newsType release];
    [_newsTitle release];
    [_newsSummary release];
    [_newsImage release];    
    [super dealloc];
}

- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic {
//    NSDictionary *mapDic = @{
//        
//    };
    
    /*
      key:  json字典的key名
      value: model对象的属性名
     */
    NSDictionary *mapDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"newsId",@"id",
                            @"newsType",@"type",
                            @"newsTitle",@"title",
                            @"newsSummary",@"summary",
                            @"newsImage",@"image",
                            nil];
    return mapDic;
}
 

@end
