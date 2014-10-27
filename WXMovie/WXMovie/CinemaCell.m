//
//  CinemaCell.m
//  WXMovie
//
//  Created by wei.chen on 13-9-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CinemaCell.h"
#import "CinemaModel.h"

#define kFontColor rgb(253, 216, 0, 1)

@implementation CinemaCell

- (void)dealloc {
    WXRelease(_ratingLabel1);
    WXRelease(_ratingLabel2);
    WXRelease(_priceLabel);
    WXRelease(_seatIcon);
    WXRelease(_couponIcon);
    WXRelease(_cinemaModel);
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
        
        //辅助图标
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)_initViews {
    _ratingLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
    _ratingLabel1.font = [UIFont systemFontOfSize:14];
    _ratingLabel1.textColor = kFontColor;
    _ratingLabel1.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_ratingLabel1];
    
    _ratingLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
    _ratingLabel2.font = [UIFont systemFontOfSize:12];
    _ratingLabel2.textColor = kFontColor;
    _ratingLabel2.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_ratingLabel2];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLabel.font = [UIFont systemFontOfSize:18];
    _priceLabel.textColor = kFontColor;
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    
    //选座图标
    _seatIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cinemaSeatMark@2x.png"]];
    [self.contentView addSubview:_seatIcon];
    
    //优惠券图标
    _couponIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cinemaCouponMark@2x.png"]];
    [self.contentView addSubview:_couponIcon];
    
    //影院标题
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    
    //子标题
    self.detailTextLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //影院名称
    self.textLabel.frame = CGRectMake(10, 5, 0, 0);
    self.textLabel.text = self.cinemaModel.name;
    [self.textLabel sizeToFit];
    if (self.textLabel.width > 200) {
        self.textLabel.width = 200;
    }
    
//    NSString *name = self.cinemaModel.name;
//    NSMutableAttributedString *attributString = [[NSMutableAttributedString alloc] initWithString:name];
//    //设置字符串的样式   NSFontAttributeName:样式名称
//    [attributString addAttribute:NSFontAttributeName
//                           value:[UIFont boldSystemFontOfSize:20]
//                           range:NSMakeRange(0, 2)];
    
//    [attributString addAttribute:NSBackgroundColorAttributeName
//                           value:[UIColor redColor]
//                           range:NSMakeRange(0, 2)];
//    self.textLabel.attributedText = attributString;
//    self.textLabel.frame = CGRectMake(10, 5, 0, 0);
//    [self.textLabel sizeToFit];
    
    
    //附近商区名称
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom+5, 0, 0);
    self.detailTextLabel.text = self.cinemaModel.circleName;
    [self.detailTextLabel sizeToFit];
    
    //价格
    NSString *price = self.cinemaModel.lowPrice;
    if (price.length == 0) {
        _priceLabel.text = nil;
    } else {
        int priceValue = [price intValue];
        _priceLabel.text = [NSString stringWithFormat:@"￥%d",priceValue];
        [_priceLabel sizeToFit];
        _priceLabel.right = self.width - 30;
        _priceLabel.top = 20;        
    }
    
    //评分
    //0.0
    NSString *grade = self.cinemaModel.grade;
    if (grade.length > 0 && [grade floatValue] > 0) {
        NSArray *comp = [grade componentsSeparatedByString:@"."];
        if (comp.count == 2) {
            NSString *r1 = [comp objectAtIndex:0];
            NSString *r2 = [comp objectAtIndex:1];
            
            _ratingLabel1.text = [NSString stringWithFormat:@"%@.",r1];
            _ratingLabel2.text = [NSString stringWithFormat:@"%@分",r2];
        }
        
        _ratingLabel1.frame = CGRectMake(self.textLabel.right+5, self.textLabel.top, 0, 0);
        [_ratingLabel1 sizeToFit];
        
        _ratingLabel2.frame = CGRectMake(_ratingLabel1.right, self.textLabel.top, 0, 0);
        [_ratingLabel2 sizeToFit];
    } else {
        _ratingLabel1.text = nil;
        _ratingLabel2.text = nil;
    }
    
    //图标
    BOOL isSeat = [self.cinemaModel.isSeatSupport boolValue];  //选座
    BOOL isCoupon = [self.cinemaModel.isCouponSupport boolValue]; //优惠券
    
    if (isSeat) {
        _seatIcon.hidden = NO;
        _seatIcon.frame = CGRectMake(10, self.detailTextLabel.bottom+5, 15, 15);
    } else {
        _seatIcon.hidden = YES;
        _seatIcon.frame = CGRectZero;
    }
    
    if (isCoupon) {
        _couponIcon.hidden = NO;
        _couponIcon.frame = CGRectMake(_seatIcon.right+5, self.detailTextLabel.bottom+5, 15, 15);
    } else {
        _couponIcon.hidden = YES;
        _couponIcon.frame = CGRectZero;
    }
}


@end
