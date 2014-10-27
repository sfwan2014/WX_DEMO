//
//  UserMetaView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-12.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeLabel.h"

@class UserModel;
@class RectButton;
@interface UserMetaView : UIView

@property(nonatomic,retain)UserModel *user;

@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet ThemeLabel *nickLabel;
@property (retain, nonatomic) IBOutlet ThemeLabel *addreeLabel;
@property (retain, nonatomic) IBOutlet ThemeLabel *infoLabel;
@property (retain, nonatomic) IBOutlet ThemeLabel *countLabel;

@property (retain, nonatomic) IBOutlet RectButton *attButton;
@property (retain, nonatomic) IBOutlet RectButton *fansButton;
@property (retain, nonatomic) IBOutlet RectButton *infoButton;
@property (retain, nonatomic) IBOutlet RectButton *moreButton;

- (IBAction)attAction:(id)sender;
- (IBAction)fansAction:(id)sender;
@end
