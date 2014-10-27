//
//  WeiboView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "ThemeImageView.h"

//微博视图在列表中显示的宽度
#define kWeiboView_width kScreenWidth-60
//微博视图在详情中显示的宽度
#define kWeiboView_width_detail kScreenWidth-20

@class WeiboModel;
@class ZoomImgeView;
@interface WeiboView : UIView<RTLabelDelegate> {
@private
    RTLabel     *_textLabel;  //显示微博内容
    ZoomImgeView *_imageView;    //微博图片
    //源微博视图
    WeiboView   *_sourceWeiboView;
    
    //源微博视图的背景
    ThemeImageView *_sourceBackgroudView;
}

@property(nonatomic,retain)WeiboModel *weiboModel;
//是否是原微博视图
@property(nonatomic,assign)BOOL isSource;
//是否在详情页面显示
@property(nonatomic,assign)BOOL isDetail;


//获取字体大小
+ (float)getFontSize:(BOOL)isDetail isSource:(BOOL)isSource;

/*
  方法描述:计算微博视图的高度
  参数： weiboModel  微博model
        isSource    是否是原微博
 */
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isSource:(BOOL)isSource
                     isDetail:(BOOL)isDetail;

@end
