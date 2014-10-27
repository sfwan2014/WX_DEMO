//
//  WeiboAnnotation.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class WeiboModel;
@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic,retain)WeiboModel *weiboModel;

- (id)initWithWeibo:(WeiboModel *)weibo;

@end
