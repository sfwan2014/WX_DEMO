//
//  NewsDetailViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ImageDetailViewController.h"
#import "WXNavigationController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (void)dealloc {
    [_activityView release];
    [_webView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"无限新闻";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-20-44)];
    //缩放网页大小来适应屏幕的尺寸
//    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    //创建风火轮控件
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_activityView stopAnimating];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_activityView];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
//    NSURL *url = [NSURL URLWithString:@"http://www.iphonetrain.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //加载一个链接请求
//    [_webView loadRequest:request];

    /*
    NSString *fileHtml = [[NSBundle mainBundle] pathForResource:@"test.html" ofType:NULL];
    NSString *html = [NSString stringWithContentsOfFile:fileHtml encoding:NSUTF8StringEncoding error:NULL];
    
    NSURL *resourceURL = [[NSBundle mainBundle] resourceURL];
    [_webView loadHTMLString:html baseURL:resourceURL];
     */
    

    //html文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"news.html" ofType:NULL];
    //html文件中的内容
    NSString *filehtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSURL *resourceURL = [[NSBundle mainBundle] resourceURL];
    
    NSDictionary *jsonDic = [WXDataService requestData:news_detail];
    NSString *content = [jsonDic objectForKey:@"content"];
    NSString *title = [jsonDic objectForKey:@"title"];
    NSString *time = [jsonDic objectForKey:@"time"];
    NSString *source = [jsonDic objectForKey:@"source"];
    NSString *author = [jsonDic objectForKey:@"author"];
    
    //副标题
    NSString *subtitle = [NSString stringWithFormat:@"%@ %@",source,time];
    NSString *at = [NSString stringWithFormat:@"(编辑：%@)",author];
    
    //拼接完整的html
    NSString *html = [NSString stringWithFormat:filehtml,title,subtitle,content,at];
    
    //加载html字符串
    [_webView loadHTMLString:html baseURL:resourceURL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
click:Http://img31.mtime.cn/CMS/News/2013/08/31/142834.54337748.jpg;Http://img31.mtime.cn/CMS/News/2013/08/31/142737.60622977.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142834.54337748.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142735.22446758.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142738.86649567.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142856.73878839.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142739.89615182.jpg    
 */
- (void)showImage:(NSString *)urlstring {
    NSArray *urlArray = [urlstring componentsSeparatedByString:@";"];
    if (urlArray.count == 0) {
        return;
    }
    /* 
      ["","","",""]
     */
    NSRange rang = NSMakeRange(1, urlArray.count-1);
    //所有的图片URL
    NSArray *images = [urlArray subarrayWithRange:rang];
    
    //click:Http://img31.mtime.cn/CMS/News/2013/08/31/142834.54337748.jpg
    NSString *clickURL = [urlArray objectAtIndex:0];
    NSRange rang2 = [clickURL rangeOfString:@":"];
    NSString *selectImage = [clickURL substringFromIndex:rang2.location+1];
    
    NSUInteger index = [images indexOfObject:selectImage];
    if (index == NSNotFound) {
        return;
    }
    
    ImageDetailViewController *imageDetail = [[ImageDetailViewController alloc] init];
    imageDetail.data = images;
    imageDetail.index = index;
    imageDetail.title = @"图片浏览";
    imageDetail.isModalButton = YES;
    
    WXNavigationController *navigation = [[WXNavigationController alloc] initWithRootViewController:imageDetail];
    [self presentViewController:navigation animated:YES completion:NULL];
    
    [navigation release];
    [imageDetail release];
    
}

//html ---> IOS
//ios ---> html
#pragma mark - UIWebView delegate
/*
//将要加载一个请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlstring = [request.URL absoluteString];
    if ([urlstring hasPrefix:@"click"]) {
        NSLog(@"%@",urlstring);
        NSLog(@"使用ImageView 显示此图片");
        
        //执行js代码
        [webView stringByEvaluatingJavaScriptFromString:@"var text=document.getElementById('textId');text.value='无限互联'"];
        
        return NO;
    }
    
    return YES;
}
 */

//将要加载一个请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    /*
     click:Http://img31.mtime.cn/CMS/News/2013/08/31/142834.54337748.jpg;Http://img31.mtime.cn/CMS/News/2013/08/31/142737.60622977.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142834.54337748.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142735.22446758.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142738.86649567.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142856.73878839.jpg;http://img31.mtime.cn/CMS/News/2013/08/31/142739.89615182.jpg     
     */
    NSString *urlstring = [request.URL absoluteString];
    if ([urlstring hasPrefix:@"click"]) {
        [self showImage:urlstring];
    }
    return YES;
}


//已经开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //开始转动
    [_activityView startAnimating];
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //停止转动
    [_activityView stopAnimating];
}

@end
