//
//  WXDataService.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-16.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^CompletionLoadHandle)(id result);

@interface WXDataService : NSObject

//网络请求
+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                             block:(CompletionLoadHandle)block;

//登陆
+ (ASIHTTPRequest *)requestLogin:(NSString *)username
                        password:(NSString *)password
                           block:(CompletionLoadHandle)block;

@end
