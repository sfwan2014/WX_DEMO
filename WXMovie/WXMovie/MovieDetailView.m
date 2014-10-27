//
//  MovieDetailView.m
//  WXMovie
//
//  Created by wei.chen on 13-9-2.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MovieDetailView.h"
#import "RatingView.h"
#import "MovieModel.h"
#import "UIImageView+WebCache.h"

@implementation MovieDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        //1.加载、解析xib文件
        //2.创建视图对象
        _contentView = [[[NSBundle mainBundle] loadNibNamed:@"MovieDetailView" owner:self options:nil] lastObject];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView retain];
        [self addSubview:_contentView];
        
//        _rtView = [[RatingView alloc] initWithFrame:CGRectMake(10, 180, 0, 30)];
//        [self addSubview:_rtView];
        
        RatingView *rtView = (RatingView *)[_contentView viewWithTag:15];
        rtView.scoreLabel.font = [UIFont boldSystemFontOfSize:18];
        
    }
    return self;
}

/*
  layoutSubviews 调用的条件：
  1.此视图被添加到父视图上面后，渲染时调用
  2.此视图的frame被修改了也会调用
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
//    _rtView.scoreNum = [_movie.rating objectForKey:@"average"];
    RatingView *rtView = (RatingView *)[_contentView viewWithTag:15];
    rtView.scoreNum = [_movie.rating objectForKey:@"average"];
    
    _contentView.frame = CGRectMake(0, 30, self.width, self.height-30);
    
    UIImageView *imageView = (UIImageView *)[_contentView viewWithTag:10];
    NSString *urlstring = [_movie.images objectForKey:@"medium"];
    [imageView setImageWithURL:[NSURL URLWithString:urlstring]];
    
    UILabel *titleLabel = (UILabel *)[_contentView viewWithTag:11];
    UILabel *orgTitleLabel = (UILabel *)[_contentView viewWithTag:12];
    UILabel *yearLabel = (UILabel *)[_contentView viewWithTag:13];
    
    titleLabel.text = [NSString stringWithFormat:@"中文名：%@",_movie.title];
    orgTitleLabel.text = [NSString stringWithFormat:@"英文名：%@",_movie.original_title];
    yearLabel.text = [NSString stringWithFormat:@"年份：%@",_movie.year];
}

@end
