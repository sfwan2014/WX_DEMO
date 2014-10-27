//
//  WeiboCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "ThemeLabel.h"
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "UserHeaderView.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
        
//        self.selectedColorKeyName = @"Timeline_Selected_Content_color";
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)_initViews {
    //用户头像
    _userImage = [[UserHeaderView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_userImage];
    
    //昵称
    _nickLabel = [[ThemeLabel alloc] initWithFrame:CGRectZero];
    _nickLabel.font = [UIFont systemFontOfSize:14];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.colorKeyName = @"Timeline_Name_color";
    [self.contentView addSubview:_nickLabel];
    
    //转发数
    _repostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostLabel.backgroundColor = [UIColor clearColor];
    _repostLabel.textColor = [UIColor blueColor];
    _repostLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_repostLabel];
    
    //评论数
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.textColor = [UIColor blueColor];
    _commentLabel.font = [UIFont systemFontOfSize:12];
    _commentLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_commentLabel];
    
    //微博来源
    _sourceLabel = [[ThemeLabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.textColor = [UIColor blueColor];
    _sourceLabel.font = [UIFont systemFontOfSize:12];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.colorKeyName = @"Timeline_Time_color";
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间
    _createLabel = [[ThemeLabel alloc] initWithFrame:CGRectZero];
    _createLabel.backgroundColor = [UIColor clearColor];    
    _createLabel.textColor = [UIColor blueColor];
    _createLabel.font = [UIFont systemFontOfSize:12];
    _createLabel.colorKeyName = @"Timeline_Time_color";
    [self.contentView addSubview:_createLabel];
    
    //创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_weiboView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _userImage.frame = CGRectMake(5, 5, 35, 35);
    //头像url
    NSString *userImgUrl = _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImgUrl]];
    _userImage.user = _weiboModel.user;
    
    //昵称
    _nickLabel.frame = CGRectMake(_userImage.right+10, _userImage.top, 200, 20);
    _nickLabel.text = _weiboModel.user.screen_name;
    
    //微博视图
    //计算微博视图的高度
    float h = [WeiboView getWeiboViewHeight:self.weiboModel isSource:NO isDetail:NO];
    _weiboView.weiboModel = self.weiboModel;
    _weiboView.frame = CGRectMake(_userImage.right+10, _nickLabel.bottom+10, kWeiboView_width, h);
    
    //发布时间
    //Sun Oct 06 17:13:19 +0800 2013
    //E M d HH:mm:ss Z yyyy
    
    NSString *createDate = _weiboModel.createDate;
    if (createDate.length != 0) {
        _createLabel.hidden = NO;
        
        //1.将字符串格式化为日期对象
        NSDate *date = [UIUtils dateFromString:createDate formate:@"E M d HH:mm:ss Z yyyy"];
        //2.将日期对象格式化为目标字符串
        NSString *datestring = [UIUtils stringFromDate:date formate:@"MM-dd HH:mm"];
        _createLabel.text = datestring;
        _createLabel.frame = CGRectMake(50, self.height-20, 100, 20);
        [_createLabel sizeToFit];
    } else {
        _createLabel.hidden = YES;
    }
    
    //<a href="http://weibo.com/" rel="nofollow">新浪微博</a>
    NSString *source = _weiboModel.source;
    NSString *result = [UIUtils parseSourceText:source];
    _sourceLabel.text = result;
    _sourceLabel.frame = CGRectMake(_createLabel.right+8, _createLabel.top, 100, 20);
    [_sourceLabel sizeToFit];

}

@end
