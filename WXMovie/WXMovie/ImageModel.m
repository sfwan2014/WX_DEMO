//
//  ImageModel.m
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

- (void)dealloc {
    WXRelease(_imageId);
    WXRelease(_image);
    WXRelease(_type);
    [super dealloc];
}


- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic {
    NSDictionary *dic = @{
                          @"id": @"imageId",
                          @"image": @"image",
                          @"type": @"type",                          
                         };
    return dic;
}

@end
