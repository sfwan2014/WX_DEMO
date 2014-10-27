//
//  WXFaceView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-16.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *faceName);

@interface WXFaceView : UIView {
    NSMutableArray *_items;
    //放大镜视图
    UIImageView *_magnifierView;
}

@property(nonatomic,assign)int pageNumber;
@property(nonatomic,copy)NSString *selectedFaceName;
@property(nonatomic,copy)SelectedBlock block;

@end
