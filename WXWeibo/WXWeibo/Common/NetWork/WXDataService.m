//
//  WXDataService.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-16.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXDataService.h"
#import "NSString+URLEncoding.h"

#define BASE_URL @"https://api.weibo.com/2/"
#define Login_URL @"https://api.weibo.com/oauth2/access_token"

@implementation WXDataService

//网络请求
+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                             block:(CompletionLoadHandle)block {
    
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    //1.获取认证的授权令牌
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    //令牌字符串
    NSString *accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
    if (accessToken.length == 0) {
        return nil;
    } else {
        //2.将令牌添加到请求参数
        [params setObject:accessToken forKey:@"access_token"];
    }
    
    
    //3.如果是GET请求，将参数拼接到url后面
    //https://api.weibo.com/2/statuses/home_timeline.json?key=value&key2=value2
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",BASE_URL,urlstring];
    if ([httpMethod isEqualToString:@"GET"] && params.count > 0) {
        [url appendString:@"?"];
        NSArray *allkeys = [params allKeys];
        for (int i=0; i<allkeys.count; i++) {
            NSString *key = [allkeys objectAtIndex:i];
            NSString *value = [params objectForKey:key];
            
            //url编码
            value = [value URLEncodedString];
            
            [url appendFormat:@"%@=%@",key,value];
            
            if (i<allkeys.count-1) {
                [url appendString:@"&"];
            }
        }
    }
    
    //4.创建request请求
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:httpMethod];
    [request setTimeOutSeconds:60];
    
    //5.判断是否为POST请求，向请求体中添加参数
    if ([httpMethod isEqualToString:@"POST"]) {
        for (NSString *key in params) {
            id value = [params objectForKey:key];
            //判断是否为文件数据
            if ([value isKindOfClass:[NSData class]]) {
                [request addData:value forKey:key];
            } else {
                [request addPostValue:value forKey:key];
            }
        }
    }
    
    //6.数据返回的处理
    [request setCompletionBlock:^{
        NSString *responseString = request.responseString;
        WXLog(@"url=%@",url);
        WXLog(@"%@",responseString);
        
        NSData *jsonData = request.responseData;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (block != nil) {
            block(result);
        }
    }];
    
    //7.请求失败
    [request setFailedBlock:^{
        WXLog(@"请求失败:%@",request.error);
    }];
    
    //8.发送异步请求
    [request startAsynchronous];
    
    return request;
}

//登陆
+ (ASIHTTPRequest *)requestLogin:(NSString *)username
                        password:(NSString *)password
                           block:(CompletionLoadHandle)block {
    
    NSArray *keys = @[@"client_id",@"client_secret",@"grant_type",@"username",@"password"];
    NSArray *values = @[kAppKey,kAppSecret,@"password",username,password];
    
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@?",Login_URL];
    for (int i=0; i<keys.count; i++) {
        NSString *key = keys[i];
        NSString *value = values[i];
        
        //url编码
        value = [value URLEncodedString];

        [url appendFormat:@"%@=%@",key,value];
        if (i < keys.count - 1) {
            [url appendString:@"&"];
        }
    }
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:60];
    [request setCompletionBlock:^{
        NSData *jsonData = request.responseData;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (block != nil) {
            block(result);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"登陆请求失败");
    }];
    
    [request startAsynchronous];
    
    return request;
}



@end
