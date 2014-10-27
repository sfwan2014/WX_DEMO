//
//  ZoomImgeView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-14.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ZoomImgeView.h"
#import "DDProgressView.h"
#import "MBProgressHUD.h"
#import "GifView.h"

@implementation ZoomImgeView

- (void)dealloc {
    WXRelease(_scrollView);
    WXRelease(_fullImageView);
    WXRelease(_progressView);
    WXRelease(_data);
    WXRelease(_urlstring);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addZoom:(NSString *)urlstring {
    
    if (self.urlstring.length == 0) {
        //放大图片的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomInAction)];
        [self addGestureRecognizer:tap];
        [tap release];
        
        self.userInteractionEnabled = YES;
    }
    
    self.urlstring = urlstring;
}

- (void)_loadViews {
    //1.创建滚动视图
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.window addSubview:_scrollView];
        
        //缩小的手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOutAction)];
        [_scrollView addGestureRecognizer:tap];
        [tap release];
    }
    
    //2.创建全屏图片视图
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithImage:self.image];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_fullImageView];
    }
    
    //3.创建进度条视图
    if (_progressView == nil) {
        _progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(10, kScreenHeight/2, kScreenWidth-20, 50)];
        _progressView.outerColor = [UIColor clearColor];
        _progressView.innerColor = [UIColor lightGrayColor];
        _progressView.emptyColor = [UIColor darkGrayColor];
        _progressView.progress = 0;
        _progressView.hidden = YES;
        [_scrollView addSubview:_progressView];
    }
    
    //创建保存按钮
    if (_saveButton == nil) {
        _saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_saveButton setImage:[UIImage imageNamed:@"compose_savebutton_background.png"] forState:UIControlStateNormal];
        [_saveButton setImage:[UIImage imageNamed:@"compose_savebutton_background_highlighted.png"] forState:UIControlStateHighlighted];
        _saveButton.frame = CGRectMake(kScreenWidth-20-23, kScreenHeight-20-19, 23, 19);
        [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.hidden = YES;
        [self.window addSubview:_saveButton];
    }
}

//放大图片
- (void)zoomInAction {
    //1.创建放大显示的视图
    [self _loadViews];
    self.hidden = YES;
    
#warning  回调代理对象，将要放大图片的协议
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:_scrollView];
    }
    
    
    //2.隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    //3.放大的动画效果
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _scrollView.backgroundColor = [UIColor clearColor];
    _fullImageView.frame = frame;
    [UIView animateWithDuration:0.3 animations:^{
        _fullImageView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        _saveButton.hidden = NO;
        
#warning  回调代理对象，已经放大图片的协议        
        if ([self.delegate respondsToSelector:@selector(imageDidZoomIn:)]) {
            [self.delegate imageDidZoomIn:_scrollView];
        }        
    }];
    
    //4.加载图片
    if (self.urlstring.length > 0) {
        //显示加载进度
        [_progressView performSelector:@selector(setHidden:) withObject:NO afterDelay:0.3];
        
        WXRelease(_data);
        _data = [[NSMutableData alloc] init];
        NSURL *url = [NSURL URLWithString:self.urlstring];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];        
    }
}

//缩小图片
- (void)zoomOutAction {
#warning  回调代理对象，将要缩小图片的协议
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:_scrollView];
    }
    
    
    //1.显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //2.缩小的动画效果
    _scrollView.backgroundColor = [UIColor clearColor];
    _progressView.hidden = YES;
    _saveButton.hidden = YES;
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
    } completion:^(BOOL finished) {
        self.hidden = NO;
        //3.释放放大产生的视图
        [_scrollView removeFromSuperview];
        
        WXRelease(_scrollView);
        WXRelease(_fullImageView);
        WXRelease(_progressView);
        WXRelease(_saveButton);
        
        //取消请求
        [self.connection cancel];
        WXRelease(_connection);
        
#warning  回调代理对象，已经缩小图片的协议
        if ([self.delegate respondsToSelector:@selector(imageDidZoomOut:)]) {
            [self.delegate imageDidZoomOut:_scrollView];
        }
    }];
    
}

//保存按钮事件
- (void)saveAction {
    UIImage *image = _fullImageView.image;
    if (image != nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"正在保存...";
        hud.dimBackground = YES;
        
        //将图片保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), hud);
    }
}

//图片保存至相册调用的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    
    MBProgressHUD *hud = contextInfo;
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //显示模式设置为自定义
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟1秒种隐藏
    [hud hide:YES afterDelay:1.5];
}

#pragma mark - NSURLConnection delegate
//1.服务器响应后调用的协议方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    
    //从响应头中获取服务器返回数据的长度
    NSString *size = [allHeaderFields objectForKey:@"Content-Length"];
    _length = [size doubleValue];
}

//2.接受数据时，实时调用的协议方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //追加数据
    [_data appendData:data];
    
    // _data.length 已加载下的数据长度， _length是总长度
    float progress = _data.length/_length;

    _progressView.progress = progress;
}

//3.数据加载完之后调用的协议方法
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (!self.isGif) {
        UIImage *image = [UIImage imageWithData:_data];
        _fullImageView.image = image;
        
        //    //原图的高度/原图的宽度 = 480/320
        //    //原图的高度/原图的宽度 = ?/320
        //图片等比例缩放
        float height = image.size.height/image.size.width * kScreenWidth;
        if (height < kScreenHeight) {
            _fullImageView.top = (kScreenHeight-height)/2;
        }
        
        _fullImageView.size = CGSizeMake(kScreenWidth, height);
        _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    } else {
        
        [_fullImageView removeFromSuperview];
        
        /*
          播放GIF图片的方式：
          1.webView播放
          2.开源的控件
         */
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//        webView.userInteractionEnabled = NO;
//        webView.backgroundColor = [UIColor clearColor];
//        webView.scalesPageToFit = YES;
//        webView.opaque = NO;
//        [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//        [_scrollView addSubview:webView];
//        _fullImageView = webView;
        
        GifView *gifView = [[GifView alloc] initWithFrame:_scrollView.bounds
                                                     data:_data];
        [_scrollView addSubview:gifView];
        _fullImageView = gifView;
        
        UIImage *image = [UIImage imageWithData:_data];
        float height = image.size.height/image.size.width * kScreenWidth;
        gifView.size = CGSizeMake(kScreenWidth, height);
        gifView.top = (kScreenHeight-height)/2;
    }
    
    //移除进度
    _progressView.progress = 1;
    [_progressView removeFromSuperview];
    
}

@end
