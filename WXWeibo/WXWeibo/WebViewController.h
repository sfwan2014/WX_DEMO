//
//  WebViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-12.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

@property(nonatomic,copy)NSString *url;

- (id)initWithUrl:(NSString *)url;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)goBack:(id)sender;
- (IBAction)forwardAction:(id)sender;
- (IBAction)refreshAction:(id)sender;
- (IBAction)openAction:(id)sender;

@end
