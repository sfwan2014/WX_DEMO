//
//  NewsCell.h
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsModel;
@interface NewsCell : UITableViewCell {
    UIImageView *_iconView;
}

@property(nonatomic,retain)NewsModel *news;

@end
