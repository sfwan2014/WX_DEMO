//
//  WeiboAnnotationView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews {
    userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    userImage.layer.borderWidth = 1;
    
    weiboImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    weiboImg.backgroundColor = [UIColor blackColor];
    
    textLable = [[UILabel alloc] initWithFrame:CGRectZero];
    textLable.font = [UIFont systemFontOfSize:12];
    textLable.textColor = [UIColor whiteColor];
    textLable.backgroundColor = [UIColor clearColor];
    textLable.numberOfLines = 3;
    
    [self addSubview:weiboImg];
    [self addSubview:userImage];
    [self addSubview:textLable];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.annotation;
    WeiboModel *weibo = nil;
    if ([self.annotation isKindOfClass:[WeiboAnnotation class]]) {
        WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)self.annotation;
        weibo = weiboAnnotation.weiboModel;
    } else {
        return;
    }
    
    //微博图url
    NSString *thumbnailImage = weibo.thumbnailImage;
    if (![thumbnailImage isEqualToString:@""] && thumbnailImage != nil) {
        //带微博图片
        
        textLable.hidden = YES;
        weiboImg.hidden = NO;
        
        //设置背景
        self.image = [UIImage imageNamed:@"nearby_map_photo_bg.png"];
        
        //微博图片
        weiboImg.frame = CGRectMake(15, 15, 90, 85);
        [weiboImg setImageWithURL:[NSURL URLWithString:thumbnailImage]];
        
        //用户头像
        userImage.frame = CGRectMake(70, 70, 30, 30);
        NSString *profileUrl = weibo.user.profile_image_url;
        [userImage setImageWithURL:[NSURL URLWithString:profileUrl]];
        
    } else {
        //不带图片
        textLable.hidden = NO;
        weiboImg.hidden = YES;
        
        //设置背景
        self.image = [UIImage imageNamed:@"nearby_map_content.png"];
        
        //用户头像
        userImage.frame = CGRectMake(20, 20, 45, 45);
        NSString *profileUrl = weibo.user.profile_image_url;
        [userImage setImageWithURL:[NSURL URLWithString:profileUrl]];
        
        //微博内容
        textLable.frame = CGRectMake(userImage.right+5, userImage.top, 110, 45);
        textLable.text = weibo.text;
    }
}

@end
