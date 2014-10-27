//
//  TopGridView.m
//  WXMovie
//
//  Created by wei.chen on 13-9-6.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "TopGridView.h"
#import "RatingView.h"
#import "MovieModel.h"
#import "UIButton+WebCache.h"
#import "MovieDetailViewController.h"

@implementation TopGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews {
    //创建电影图片按钮
    _bgView = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_bgView addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bgView];
    
    //电影标题Label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self addSubview:_titleLabel];
    
    //星星视图
    _rtView = [[RatingView alloc] initWithFrame:CGRectZero];
    _rtView.scoreLabel.font = [UIFont systemFontOfSize:12];
    _rtView.scoreLabel.textColor = [UIColor whiteColor];
    [self addSubview:_rtView];
    
}

- (void)setMovie:(MovieModel *)movie {
    if (_movie != movie) {
        [_movie release];
        _movie = [movie retain];
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bgView.frame = CGRectMake(0, 0, self.width, self.height-20);
    NSString *urlstring = [_movie.images objectForKey:@"medium"];
    [_bgView setImageWithURL:[NSURL URLWithString:urlstring]];
    
    _titleLabel.frame = CGRectMake(0, _bgView.height-15, self.width, 15);
    _titleLabel.text = _movie.title;
    
    _rtView.frame = CGRectMake(0, _bgView.bottom, 0, 15);
    _rtView.scoreNum = [_movie.rating objectForKey:@"average"];
    
}

- (void)touchAction:(UIButton *)button {
    MovieDetailViewController *movieDetail = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];
    movieDetail.movieId = _movie.usId;
    [self.viewController.navigationController pushViewController:movieDetail animated:YES];
    [movieDetail release];
}



@end
