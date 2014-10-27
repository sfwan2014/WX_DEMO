//
//  RatingView.h
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
  星星评分视图的封装
 */
@interface RatingView : UIView {
    UIView *_yelloView; //金色星星视图
    UIView *_grayView;  //灰色星星
    UILabel *_scoreLabel;   //显示评分
}

@property(nonatomic,retain)NSNumber *scoreNum;
@property(nonatomic,retain)UILabel *scoreLabel;

@end
