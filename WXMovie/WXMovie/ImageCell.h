//
//  ImageCell.h
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell {
    NSMutableArray *_buttonImages;  //4个button
}

@property(nonatomic,retain)NSArray *data;  //有可能少于4个

@end
