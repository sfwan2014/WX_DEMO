//
//  WeiboAnnotation.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboAnnotation.h"
#import "WeiboModel.h"

@implementation WeiboAnnotation

- (id)initWithWeibo:(WeiboModel *)weibo {
    self = [super init];
    if (self) {
        self.weiboModel = weibo;
    }
    
    return self;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    NSDictionary *geo = _weiboModel.geo; //nsnull
    if ([geo isKindOfClass:[NSDictionary class]]) {
        NSArray *coordinates = [geo objectForKey:@"coordinates"];
        if (coordinates.count == 2) {
            float lat = [[coordinates objectAtIndex:0] floatValue];
            float lon = [[coordinates objectAtIndex:1] floatValue];
            _coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
        
    }
    
}


@end
