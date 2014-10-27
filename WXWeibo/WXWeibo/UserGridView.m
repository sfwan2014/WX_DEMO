//
//  UserGridView.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserGridView.h"
#import "UserModel.h"
#import "ProfileViewController.h"
#import "UIView+ViewController.h"
#import "UserHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ThemeImageView.h"

@implementation UserGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super  awakeFromNib];
    backgroundView.imgName = @"profile_button3_1.png";
}

- (void)setUser:(UserModel *)user {
    if (_user != user) {
        [_user release];
        _user = [user retain];
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //昵称
    nickLabel.text = _user.screen_name;
    
    //用户头像
    NSString *urlstring = _user.profile_image_url;
    [userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    userImage.user = _user;
    
    //粉丝数
    long fansValue = [self.user.followers_count longValue];
    if (fansValue >= 10000) {
        fansValue /= 10000;
        fansLabel.text = [NSString stringWithFormat:@"%ld万粉丝",fansValue];
    } else {
        fansLabel.text = [NSString stringWithFormat:@"%ld粉丝",fansValue];
    }
}

- (void)dealloc {
    [backgroundView release];
    [super dealloc];
}
@end
