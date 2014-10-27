//
//  PhotoScrollView.h
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoTableView;
@interface PhotoScrollView : UIScrollView<UIScrollViewDelegate> {
    UIImageView *_imageView;
}

@property(nonatomic,retain)NSURL *url;

@property(nonatomic,retain)PhotoTableView *tableView;
@property(nonatomic,assign)int row;

@end
