//
//  WebViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-12.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _loadData];
}

- (void)_loadData {
    
    if (self.url.length > 0) {
        self.title = @"载入中...";
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:request];
        
        //状态栏上显示loading
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //停止加载
    [self.webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}

#pragma mark - UIWebView delegate
//网页加载完成的协议方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.title = title;
}


#pragma mark - actions
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)forwardAction:(id)sender {
    [self.webView goForward];
}

- (IBAction)refreshAction:(id)sender {
    [self.webView reload];
}

- (IBAction)openAction:(id)sender {
    //提示用户，打开链接
    
    //http://
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
}
@end
