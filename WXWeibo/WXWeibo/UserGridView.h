//
//  UserGridView.h
//  WXWeibo
//
//  Created by wei.chen on 13-5-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@class UserHeaderView;
@class ThemeImageView;
@interface UserGridView : UIView {
    
    IBOutlet UserHeaderView *userImage;
    IBOutlet UILabel *nickLabel;
    IBOutlet UILabel *fansLabel;
    IBOutlet ThemeImageView *backgroundView;
}

@property(nonatomic,retain)UserModel *user;


@end
