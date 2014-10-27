//
//  ProfileViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@class WeiboTableView;
@class UserMetaView;
@interface ProfileViewController : BaseViewController {
    UserMetaView *_userView;
    
    NSMutableArray *_requests;
}

@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *nickName;

//是否为当前登录用户的个人中心控制器
@property(nonatomic,assign)BOOL isLoginUser;

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;
@end
