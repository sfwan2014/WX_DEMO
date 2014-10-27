//
//  RatingView.m
//  WXMovie
//
//  Created by wei.chen on 13-8-30.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "RatingView.h"

#define kRatingLabelWidth 30

@implementation RatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)awakeFromNib {
    [self _initViews];
}

- (void)_initViews {
    /* 显示五个星星设计原理
     图片只提供了一个星星，要显示五个星星：
     首先，压缩一个星星图片为固定大小。使用colorWithPatternImage把一个星星当成color传进去，然后再设置图片的仿射变换，缩放比率用固定的大小除以图片原来的大小，这样不管一个星星图片有多大，始终显示为固定的大小。
     其次，使用colorWithPatternImage方法的时候，当图片的大小 小于等于 要设置的视图的大小的时候，图片会平铺，这样就达到了显示五个星星的目的。
     这样设计更精炼，无需太多代码和复杂的逻辑
     */
    
    //1.初始化灰色星星
    _grayView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_grayView];
    
    //2.初始化金色星星
    _yelloView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_yelloView];
    
    //3.创建Label
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _scoreLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_scoreLabel];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setFrame:(CGRect)frame {
    CGFloat star5Width = frame.size.height * 5;
    frame.size.width = star5Width + kRatingLabelWidth;

    [super setFrame:frame];
//    super.frame = frame;
}

- (void)setScoreNum:(NSNumber *)scoreNum {
    if (_scoreNum != scoreNum) {
        [_scoreNum release];
        _scoreNum = [scoreNum retain];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //5个星星铺满后的宽度
    CGFloat grayWidth = self.height * 5;
    
    //压缩星星
    UIImage *grayImg = [UIImage imageNamed:@"gray@2x.png"];
    _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImg];
    _grayView.transform = CGAffineTransformMakeScale(self.height/grayImg.size.width, self.height/grayImg.size.height);
    
    UIImage *yelloImg = [UIImage imageNamed:@"yellow@2x.png"];
    _yelloView.transform = CGAffineTransformMakeScale(self.height/yelloImg.size.width, self.height/yelloImg.size.height);
    _yelloView.backgroundColor = [UIColor colorWithPatternImage:yelloImg];
    
    _grayView.frame = CGRectMake(0, 0, grayWidth, self.height);
    _yelloView.frame = CGRectMake(0, 0, grayWidth, self.height);
    _scoreLabel.frame = CGRectMake(grayWidth+5, 0, kRatingLabelWidth, self.height);    
    
    float score = [_scoreNum floatValue];
    _scoreLabel.text = [NSString stringWithFormat:@"%0.1f",score];
    
    //分数的百分比
    float s = score/10;
    //根据分数的百分比调整_yelloView视图的宽度
    _yelloView.width = s * grayWidth;
    
}

@end
