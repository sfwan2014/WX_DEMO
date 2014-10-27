//
//  WeiboAnnotationView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WeiboAnnotationView : MKAnnotationView {
@private
    UIImageView *userImage;  //用户头像
    UIImageView *weiboImg;  //微博图片视图
    UILabel     *textLable; //微博内容
}

@end
