//
//  ImageModel.h
//  WXMovie
//
//  Created by wei.chen on 13-9-3.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseModel.h"

/*
 {
 "id": 2238621,
 "image": "http://img31.mtime.cn/pi/2013/02/04/093444.29353753_1280X720.jpg",
 "type": 6
 }
 */
@interface ImageModel : BaseModel

@property(nonatomic,retain)NSNumber *imageId;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,retain)NSNumber *type;

@end
