//
//  CinemaCell.h
//  WXMovie
//
//  Created by wei.chen on 13-9-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CinemaModel;
@interface CinemaCell : UITableViewCell {
    UILabel *_ratingLabel1;  //评分Label;
    UILabel *_ratingLabel2;  //评分Label
    UILabel *_priceLabel;   //价格Label
    
    UIImageView *_seatIcon; //支持选中图标
    UIImageView *_couponIcon;   //支持优惠券
}

@property(nonatomic,retain) CinemaModel *cinemaModel;

@end
