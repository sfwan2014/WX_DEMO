//
//  CommentCell.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "UIUtils.h"
#import "UserHeaderView.h"
#import "UIView+ViewController.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _rtTextLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _rtTextLabel.font = [UIFont systemFontOfSize:14.0f];
    _rtTextLabel.delegate = self;
    _rtTextLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //设置超链接高亮的颜色
    _rtTextLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_rtTextLabel];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //用户头像
    UserHeaderView *userImage = (UserHeaderView *)[self.contentView viewWithTag:100];
    userImage.layer.cornerRadius = 5;
    userImage.layer.masksToBounds = YES;
    userImage.layer.borderColor = [UIColor grayColor].CGColor;
    userImage.layer.borderWidth = 1;
    NSString *urlstring = _commentModel.user.profile_image_url;
    [userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    userImage.user = _commentModel.user;
    
    //昵称
    UILabel *nickLabel = (UILabel *)[self.contentView viewWithTag:101];
    nickLabel.text = _commentModel.user.screen_name;
    
    //发布时间
    UILabel *timeLabel = (UILabel *)[self.contentView viewWithTag:102];
    timeLabel.text = [UIUtils fomateString:_commentModel.created_at];
    
    
    //评论内容
    _rtTextLabel.frame = CGRectMake(userImage.right+10, nickLabel.bottom+5, 240, 21);
    _rtTextLabel.text = [UIUtils parseLinkText:_commentModel.text];
    _rtTextLabel.height = _rtTextLabel.optimumSize.height;
}

//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel {
    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.font = [UIFont systemFontOfSize:14.0f];
    rt.text = commentModel.text;
    
    return rt.optimumSize.height;
}

#pragma mark - RTLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    [UIUtils didSelectLinkWithURL:url viewController:self.viewController];
}
@end
