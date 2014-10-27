//
//  CommentCell.h
//  WXWeibo
//
//  Created by wei.chen on 13-5-20.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "BaseCell.h"

@class CommentModel;
@interface CommentCell : BaseCell<RTLabelDelegate> {
    RTLabel *_rtTextLabel;
}

@property(nonatomic,retain)CommentModel *commentModel;

//计算评论单元格的高度
+ (float)getCommentHeight:(CommentModel *)commentModel;

@end
