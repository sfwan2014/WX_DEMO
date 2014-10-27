//
//  WeiboCell.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseCell.h"

@class WeiboModel;
@class WeiboView;
@class ThemeLabel;
@class UserHeaderView;
@interface WeiboCell : BaseCell {
@private
    //子视图
    UserHeaderView *_userImage;    //用户头像
    ThemeLabel  *_nickLabel;    //昵称
    UILabel     *_repostLabel;  //转发数
    UILabel     *_commentLabel; //评论数
    ThemeLabel     *_sourceLabel;  //微博来源
    ThemeLabel     *_createLabel;  //发布时间
    
    //微博视图
    WeiboView   *_weiboView;
}

@property(nonatomic,retain)WeiboModel *weiboModel;

@end
