//
//  CommentCell.h
//  WXMovie
//
//  Created by wei.chen on 13-9-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentModel;
@interface CommentCell : UITableViewCell

@property(nonatomic,retain)CommentModel *commentModel;

#pragma mark - Views
@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UIImageView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;
@property (retain, nonatomic) IBOutlet UILabel *ratingLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

//计算cell的展开的高度
+ (CGFloat)cellHeight:(NSString *)content;

@end
