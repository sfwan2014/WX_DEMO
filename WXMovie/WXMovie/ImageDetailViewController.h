//
//  ImageDetailViewController.h
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

//图片浏览控制器

@interface ImageDetailViewController : BaseViewController

//所有图片url
@property(nonatomic,retain)NSArray *data;  //url
//选中的图片索引
@property(nonatomic,assign)int index;

@end
