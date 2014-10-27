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

//通过三色值获取颜色对象
#define rgb(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//安全释放
#define WXRelease(obj) [obj release];obj = nil;

////////////////////////////////////////////////////////////////////////
//设置是否调试模式
#define WXDEBUG 1

#if WXDEBUG
#define WXLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define WXLog(xx, ...)  ((void)0)
#endif // #ifdef DEBUG
////////////////////////////////////////////////////////////////////////

/**将下面注释取消，并定义自己的app key，app secret以及授权跳转地址uri
 此demo即可编译运行**/

//#define kAppKey             @"220948586"
//#define kAppSecret          @"fc88053c39c590734d79d97e31171316"
//#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#define kAppKey @"2323547071"
#define kAppSecret @"16ed80cc77fea11f7f7e96eca178ada3"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"



///////////////////////////////url/////////////////////////////////////////
#define home_timeline  @"statuses/home_timeline.json"  //微博列表
#define unread_count @"remind/unread_count.json"        //未读消息
#define users_profile @"users/show.json"    //用户信息
#define user_timeline @"statuses/user_timeline.json"  //用户的微博列表
#define URL_FRIENDS @"friendships/friends.json" //关注列表
#define URL_FOLOWERS @"friendships/followers.json"  //粉丝列表
#define send_update @"statuses/update.json"  //发微博（不带图）
#define send_upload @"statuses/upload.json"  //发微博（带图）
#define nearby_timeline @"place/nearby_timeline.json" //附近的微博


///////////////////////////////notification/////////////////////////////////////////
//登陆成功的通知
#define kLoginNotification @"loginDidFinishNotification"
//刷新微博表格
#define kReloadWeiboTableNotification @"ReloadWeiboTableNotification"


///////////////////////////////微博图片的浏览模式/////////////////////////////////////////
#define kLargeModel 1  //大图浏览模式
#define kSmalModel 2    //小图浏览模式
#define kNoneModel 3    //无图浏览模式
#define kBrowMode      @"browMode"

#endif
