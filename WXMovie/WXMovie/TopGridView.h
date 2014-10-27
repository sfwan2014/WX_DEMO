//
//  TopGridView.h
//  WXMovie
//
//  Created by wei.chen on 13-9-6.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;
@class MovieModel;
@interface TopGridView : UIView {
    UIButton *_bgView;
    UILabel *_titleLabel;
    RatingView *_rtView;
}

@property(nonatomic,retain) MovieModel *movie;

@end
