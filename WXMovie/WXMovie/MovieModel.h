//
//  USBoxMovie.h
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseModel.h"

/*
 {
 "rating" : {
    "stars" : "40",
    "average" : 7.3,
    "min" : 0,
    "max" : 10
 },
 "collect_count" : 49,
 "images" : {
    "small" : "http:\/\/img3.douban.com\/view\/photo\/icon\/public\/p1943399384.jpg",
    "large" : "http:\/\/img3.douban.com\/view\/photo\/photo\/public\/p1943399384.jpg",
    "medium" : "http:\/\/img3.douban.com\/view\/photo\/thumb\/public\/p1943399384.jpg"
 },
 "id" : "3170961",
 "alt" : "http:\/\/movie.douban.com\/subject\/3170961\/",
 "title" : "双枪",
 "subtype" : "movie",
 "year" : "2013",
 "original_title" : "2 Guns"
 }
 */

/*
 类描述：电影数据模型类
 */
@interface MovieModel : BaseModel

@property(nonatomic,retain)NSDictionary *rating;   //评分信息
@property(nonatomic,retain)NSNumber *collect_count; //收藏数
@property(nonatomic,retain)NSDictionary *images;    //图片url
@property(nonatomic,copy)NSString *usId;            //电影id
@property(nonatomic,copy)NSString *title;           //电影标题
@property(nonatomic,copy)NSString *year;            //上映的年份
@property(nonatomic,copy)NSString *original_title;  //原标题

@end
