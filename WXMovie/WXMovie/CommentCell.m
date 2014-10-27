//
//  CommentCell.m
//  WXMovie
//
//  Created by wei.chen on 13-9-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import <QuartzCore/QuartzCore.h>


#define kContentWidth 218

@implementation CommentCell

- (void)dealloc {
    [_userImage release];
    [_bgView release];
    [_nickLabel release];
    [_ratingLabel release];
    [_contentLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
  当前这个视图对象，使用xib形式创建，当创建的时候会调用awakeFromNib方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
    
    //创建子视图
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.contentLabel.width = kContentWidth;

    //子视图填充数据
    NSString *urlstring = _commentModel.userImage;
    [self.userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImage.layer.borderWidth = 1;
    
    self.nickLabel.text = self.commentModel.nickname;
    self.ratingLabel.text = self.commentModel.rating;
    self.contentLabel.text = self.commentModel.content;
    
    self.bgView.height = self.height-6;
    self.contentLabel.height = self.height - 40;
    
    UIImage *image = self.bgView.image;
//    UIImage *resizeImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 50)];
    UIImage *resizeImage = [image stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    self.bgView.image = resizeImage;
}

+ (CGFloat)cellHeight:(NSString *)content {
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(kContentWidth, 1000)];
    float height = size.height;
    
    return height + 50;
}

@end
