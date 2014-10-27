//
//  SendViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-15.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@class ZoomImgeView;
@class WXFaceScrollView;
@interface SendViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate> {
    
    UITextView *_textView;
    UIView *_editorBar;
    ZoomImgeView *_selectImg;  //选取的图片
    
    NSMutableArray *_editorButtons;
    
    //表情视图
    WXFaceScrollView *_faceView;
}

@property(nonatomic,retain)NSDictionary *locationData;

@end
