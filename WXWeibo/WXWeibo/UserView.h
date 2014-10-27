//
//  UserView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;
@class UserHeaderView;
@interface UserView : UIView

@property(nonatomic,retain)WeiboModel *weiboModel;

@property (retain, nonatomic) IBOutlet UserHeaderView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@property (retain, nonatomic) IBOutlet UILabel *createLabel;
@property (retain, nonatomic) IBOutlet UILabel *sourceLabel;

@end
