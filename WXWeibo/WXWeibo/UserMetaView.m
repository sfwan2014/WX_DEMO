//
//  UserMetaView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-12.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserMetaView.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "RectButton.h"
#import "FriendshipsViewController.h"
#import "UIView+ViewController.h"

@implementation UserMetaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [_userImage release];
    [_nickLabel release];
    [_addreeLabel release];
    [_infoLabel release];
    [_countLabel release];
    [_attButton release];
    [_fansButton release];
    [_infoButton release];
    [_moreButton release];
    [super dealloc];
}

- (void)setUser:(UserModel *)user {
    if (_user != user) {
        [_user release];
        _user = [user retain];
        
        [self setNeedsLayout];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.attButton.imgName = @"profile_button_9.png";
    self.fansButton.imgName = @"profile_button_9.png";
    self.infoButton.imgName = @"profile_button_9.png";
    self.moreButton.imgName = @"profile_button_9.png";
    
    self.nickLabel.colorKeyName = @"Timeline_Name_color";
    self.addreeLabel.colorKeyName = @"Timeline_Name_color";
    self.infoLabel.colorKeyName = @"Timeline_Name_color";
    self.countLabel.colorKeyName = @"Timeline_Name_color";
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //用户头像
    NSString *urlstring = self.user.avatar_large;
    [self.userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    
    //昵称
    self.nickLabel.text = self.user.screen_name;
    
    //性别
    NSString *gender = self.user.gender;
    NSString *sexName = @"未知";
    if ([gender isEqualToString:@"f"]) {
        sexName = @"女";
    }
    else if([gender isEqualToString:@"m"]) {
        sexName = @"男";
    }
    
    //地址
    NSString *location = self.user.location;
    if (location == nil) {
        location = @"";
    }
    
    self.addreeLabel.text = [NSString stringWithFormat:@"%@ %@",sexName,location];
    
    //微博数
    NSString *countString = [self.user.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共%@条微博",countString];
    
    //关注数
    long friends = [self.user.friends_count longValue];
    self.attButton.title = @"关注";
    self.attButton.subTitle = [NSString stringWithFormat:@"%ld",friends];

    //粉丝数
    long fans = [self.user.followers_count longValue];
    self.fansButton.title = @"粉丝";
    if (fans >= 10000) {
        
        fans /= 10000;
        self.fansButton.subTitle = [NSString stringWithFormat:@"%ld万",fans];
    } else {
        self.fansButton.subTitle = [NSString stringWithFormat:@"%ld",fans];
    }
    
    self.infoButton.title = @"资料";
    self.moreButton.title = @"更多";
}

//关注数
- (IBAction)attAction:(id)sender {
    FriendshipsViewController *friendships = [[FriendshipsViewController alloc] init];
    friendships.userId = _user.idstr;
    //关注列表类型
    friendships.shipType = Attention;
    [self.viewController.navigationController pushViewController:friendships animated:YES];
    [friendships release];
}

//粉丝数
- (IBAction)fansAction:(id)sender {
    FriendshipsViewController *friendships = [[FriendshipsViewController alloc] init];
    friendships.userId = _user.idstr;
    //关注列表类型
    friendships.shipType = Fans;
    [self.viewController.navigationController pushViewController:friendships animated:YES];
    [friendships release];
}
@end
