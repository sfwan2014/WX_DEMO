//
//  Common.h
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#ifndef WXMovie_Common_h
#define WXMovie_Common_h

//获取物理屏幕的尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kThemeColor     [UIColor colorWithRed:76.0f/255 green:183.0f/255 blue:252.0f/255 alpha:1.0f]
//通过三色值获取颜色对象
#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/*_________________json数据文件_________________________*/

#define usbox_json      @"us_box.json"
#define news_list       @"news_list.json"
#define image_list      @"image_list.json"    //图片列表
#define news_detail     @"news_detail.json"  //新闻详情
#define top250          @"top250.json"  
#define movie_detail    @"movie_detail.json"  //电影详情
#define movie_comment   @"movie_comment.json" //评论列表
#define cinema_list     @"cinema_list.json"     //影院列表
#define district_list   @"district_list.json"   //区列表
#define cinema_detail   @"cinema_detail.json" //影院详情

//安全释放
#define WXRelease(obj) [obj release];obj = nil;

////////////////////////////////////////////////////////////////////////
//设置是否调试模式
#define WXDEBUG 0

#if WXDEBUG
#define WXLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define WXLog(xx, ...)  ((void)0)
#endif // #ifdef DEBUG
////////////////////////////////////////////////////////////////////////


#endif
