//
//  CommentTableView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-11.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseTableView.h"

@class WeiboModel;
@class UserView;
@class WeiboView;
@interface CommentTableView : BaseTableView {
    UIView *_headerView;
    UserView *_userView;  //用户视图
    WeiboView *_weiboView;  //微博视图
}

@property(nonatomic,retain)WeiboModel *weiboModel;
@property(nonatomic,retain)NSDictionary *commentDic;

@end
