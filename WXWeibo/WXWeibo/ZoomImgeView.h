//
//  ZoomImgeView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-14.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZoomImageViewDelegate <NSObject>

@optional
//1.图片放大协议方法
- (void)imageWillZoomIn:(UIView *)view;
- (void)imageDidZoomIn:(UIView *)view;

//2.图片缩小协议方法
- (void)imageWillZoomOut:(UIView *)view;
- (void)imageDidZoomOut:(UIView *)view;

@end


@class DDProgressView;
@interface ZoomImgeView : UIImageView<NSURLConnectionDataDelegate> {
@private
    UIScrollView *_scrollView;
    UIImageView  *_fullImageView;
    DDProgressView *_progressView;
    UIButton        *_saveButton;
    
    //大图数据的长度
    double _length;
    NSMutableData *_data;
}

@property(nonatomic,copy)NSString *urlstring;
@property(nonatomic,retain)NSURLConnection *connection;
@property(nonatomic,assign)id<ZoomImageViewDelegate> delegate;
@property(nonatomic,assign)BOOL isGif;

- (void)addZoom:(NSString *)urlstring;
- (void)zoomOutAction;

@end
