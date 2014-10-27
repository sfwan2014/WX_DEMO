//
//  WXDataService.m
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXDataService.h"
#import "JSONKit.h"

/*
  json解析的框架:
 
  JSONKit   性能好
  SBJSON
  TouchJSON  
  NSJSONSerialization  ios5.0新增的类，性能最好
 */
@implementation WXDataService

+ (id)requestData:(NSString *)jsonName {
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonName ofType:nil];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:jsonName];
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    float version = [systemVersion floatValue];
    
    id jsonObj = nil;
    
    if (version >= 5.0) {
        
        //NSJSONSerialization 5.0之后ios新添加解析json的工具类
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
    } else {
        NSString *jsonData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        //jsonkit解析json字符串
        jsonObj = [jsonData objectFromJSONString];
    }
    
    return jsonObj;
}

@end
