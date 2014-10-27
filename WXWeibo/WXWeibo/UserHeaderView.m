//
//  UserHeaderView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-12.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserHeaderView.h"
#import "ProfileViewController.h"
#import "UserModel.h"
#import "UIView+ViewController.h"
#import "UIImageView+WebCache.h"

@implementation UserHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self _initViews];
}

- (void)_initViews {
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    [tap release];
    
    //设置圆弧半径
    self.layer.cornerRadius = 5;
    //超出部分的视图是否裁剪掉
    self.layer.masksToBounds = YES;
    //设置边框颜色
//    self.layer.borderColor
    //设置边框宽度
//    self.layer.borderWidth
    
}

- (void)tapAction {
    if (self.user.idstr.length == 0) {
        return;
    }
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    profile.userId = self.user.idstr;
    [self.viewController.navigationController pushViewController:profile animated:YES];
    [profile release];
}

@end
