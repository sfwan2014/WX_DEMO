//
//  WXFaceScrollView.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-16.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXFaceView.h"

@interface WXFaceScrollView : UIView<UIScrollViewDelegate> {
@private
    UIScrollView *_scrollView;
    WXFaceView *_faceView;
    UIPageControl *_pageControll;
}

- (id)initWithBlock:(SelectedBlock)block;
- (void)setBlock:(SelectedBlock)block;

@end
