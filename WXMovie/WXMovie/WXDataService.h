//
//  WXDataService.h
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
  类描述：
  提供数据的工具类
 */
@interface WXDataService : NSObject

//请求数据工具方法
+ (id)requestData:(NSString *)jsonName;


@end
