//
//  USMovieCell.h
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovieModel;
@class RatingView;
@interface USMovieCell : UITableViewCell {
    UIImageView *_imgView; //电影图片
    RatingView *_ratingView;  //星星评分视图
    
//    NSMutableArray *_starsArray;
}

@property(nonatomic,retain)MovieModel *movieModel;

@end
