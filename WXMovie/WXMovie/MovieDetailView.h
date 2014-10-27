//
//  MovieDetailView.h
//  WXMovie
//
//  Created by wei.chen on 13-9-2.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovieModel;
@class RatingView;
@interface MovieDetailView : UIView {
    UIView *_contentView;
    RatingView *_rtView;
}

@property(nonatomic,retain)MovieModel *movie;

@end
