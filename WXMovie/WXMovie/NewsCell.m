//
//  NewsCell.m
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "NewsModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsCell

- (void)dealloc {
    WXRelease(_iconView);
    WXRelease(_news);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_iconView];
        
        //标题
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.textLabel.backgroundColor = [UIColor orangeColor];
        
        //子标题
        self.detailTextLabel.textColor = [UIColor orangeColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
        self.detailTextLabel.backgroundColor = [UIColor whiteColor];
        
        //添加辅助视图
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //修改选中样式
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        
        self.imageView.image = [UIImage imageNamed:@"sctpxw.png"];
        //设置边框的宽度
        self.imageView.layer.borderWidth = 1;
        //设置边框的颜色
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSLog(@"%@ %d",self.imageView.superview,self.imageView.hidden);
    if (self.imageView.superview == nil) {
        [self.contentView addSubview:self.imageView];
    }
    
    self.imageView.frame = CGRectMake(10, 5, 50, self.height-10);
    self.textLabel.frame = CGRectMake(self.imageView.right+10, self.imageView.top, self.width-self.imageView.right-10-30, 20);
    _iconView.frame = CGRectMake(self.imageView.right+10, self.textLabel.bottom+10, 16, 12);
    self.detailTextLabel.frame = CGRectMake(_iconView.right+10, _iconView.top, self.textLabel.width-20, 15);
    
    
    //加载图片
    NSString *urlstring = _news.newsImage;
    [self.imageView setImageWithURL:[NSURL URLWithString:urlstring]];
    
    //标题
    self.textLabel.text = _news.newsTitle;
    
    //副标题
    self.detailTextLabel.text = _news.newsSummary;
    
    //类型图标
    int type = [_news.newsType intValue];
    if (type == 0) { //普通新闻
        _iconView.hidden = YES;
        self.detailTextLabel.left = self.imageView.right + 10;
    } else if(type == 1) { //图片新闻
        _iconView.image = [UIImage imageNamed:@"sctpxw.png"];
        //显示图片
        _iconView.hidden = NO;
    } else if(type == 2) { //视频新闻
        _iconView.image = [UIImage imageNamed:@"scspxw.png"];
        //显示图片
        _iconView.hidden = NO;
    }
    
}
@end
