//
//  WXTabbarItem.m
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXTabbarItem.h"

@implementation WXTabbarItem

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)imgStr title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        //1.创建子视图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-19)/2, 5, 19, 20)];
        
        //让图片不拉伸，在imageView居中显示
        imageView.contentMode = UIViewContentModeCenter;
        imageView.image = [UIImage imageNamed:imgStr];
        [self addSubview:imageView];
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, self.width, 20)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:titleLabel];
        
        [imageView release];
        [titleLabel release];
    }
    
    return self;
}


@end
