//
//  NewsModel.h
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

/*
 {
    "id" : 1491520,
    "type" : 0,
    "title" : "科幻大作《全面回忆》全新预告片发布",
    "summary" : "",
    "image" : "http://img31.mtime.cn/mg/2012/06/28/100820.21812355.jpg"
 }
 */
@interface NewsModel : BaseModel

@property(nonatomic,retain)NSNumber *newsId;  //新闻的id
@property(nonatomic,retain)NSNumber *newsType;  //新闻的类型
@property(nonatomic,copy)NSString *newsTitle;   //新闻的标题
@property(nonatomic,copy)NSString *newsSummary; //新闻的副标题
@property(nonatomic,copy)NSString *newsImage;   //新闻的图片

@end
