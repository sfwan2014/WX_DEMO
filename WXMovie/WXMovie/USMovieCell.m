//
//  USMovieCell.m
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "USMovieCell.h"
#import "UIImageView+WebCache.h"
#import "MovieModel.h"
#import "RatingView.h"

@implementation USMovieCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //取消选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.textColor = [UIColor orangeColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_imgView];
        
        _ratingView = [[RatingView alloc] initWithFrame:CGRectZero];
        _ratingView.scoreLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_ratingView];
        
        /*
        _starsArray = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i=0; i<5; i++) {
            UIImageView *starView = [[UIImageView alloc]
                                     initWithImage:[UIImage imageNamed:@"gray@2x.png"]
                                     highlightedImage:[UIImage imageNamed:@"yellow@2x.png"]];
            starView.frame = CGRectMake(100+(20*i), 50, 20, 20);
            [self.contentView addSubview:starView];
            starView.tag = i;
            
            [_starsArray addObject:starView];
            [starView release];
        }
        */
        
    }
    return self;
}

/*
  1.布局子视图，调整子视图的frame
  2.填充数据
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSString *urlstring = [_movieModel.images objectForKey:@"medium"];
    NSURL *url = [NSURL URLWithString:urlstring];
    //加载网络图片
    [_imgView setImageWithURL:url];
    
    self.textLabel.text = _movieModel.title;
    self.detailTextLabel.text = [NSString stringWithFormat:@"年份：%@",_movieModel.year];
    
    _imgView.frame = CGRectMake(10, 10, 75, 100);
    self.textLabel.frame = CGRectMake(100, 15, 200, 20);
    self.detailTextLabel.frame = CGRectMake(100, 90, 180, 20);
    
    NSNumber *averageNum = [_movieModel.rating objectForKey:@"average"];
    _ratingView.frame = CGRectMake(100, 55, 0, 20);
    _ratingView.scoreNum = averageNum;
    
    /*0~10*/
//    float avg = [averageNum floatValue];
//    for (UIImageView *starView in _starsArray) {
////        starView.tag 的取值范围(0~4)
//        int r = avg/2;
//        if (starView.tag < r) {
//            starView.highlighted = YES;
//        } else {
//            starView.highlighted = NO;
//        }
//    }
}

@end
