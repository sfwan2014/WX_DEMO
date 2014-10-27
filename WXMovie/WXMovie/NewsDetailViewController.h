//
//  NewsDetailViewController.h
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsDetailViewController : BaseViewController<UIWebViewDelegate> {
    UIWebView *_webView;
    UIActivityIndicatorView *_activityView;
}

@end
