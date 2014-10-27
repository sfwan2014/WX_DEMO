//
//  WeiboView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-7.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "ThemeManager.h"
#import "RegexKitLite.h"
#import "NSString+URLEncoding.h"
#import "ProfileViewController.h"
#import "UIView+ViewController.h"
#import "WebViewController.h"
#import "UIUtils.h"
#import "ZoomImgeView.h"

//微博图片的高度
#define kImgHeigh 80  //微博图片在列表中的高度
#define kImgHeigh_Larg 200  //大图浏览模式的图片高度

#define kImgHeigh_detail 200 //微博图片在详情页面中的高度

@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

//初始化子视图
- (void)_initViews {
    
    //1.微博内容Label
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.delegate = self;
    [self addSubview:_textLabel];
    
    //2.微博图片视图
    _imageView = [[ZoomImgeView alloc] initWithFrame:CGRectZero];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *gifIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_gif.png"]];
    gifIcon.tag = 2013;
    [_imageView addSubview:gifIcon];
    [gifIcon release];
    
    [self addSubview:_imageView];
    
    //3.原微博视图
    //在这里创建源微博会导致死循环
//    _sourceWeiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    
    //4.原微博背景视图
    _sourceBackgroudView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
    _sourceBackgroudView.leftCapWidth = 40;
    _sourceBackgroudView.topCapHeight = 40;
    _sourceBackgroudView.imgName = @"timeline_rt_border_9.png";
    _sourceBackgroudView.backgroundColor = [UIColor clearColor];
    [self insertSubview:_sourceBackgroudView atIndex:0];
    
    //监听主题切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChangeNotification:) name:kThemeDidChangeNofitication object:nil];
    
    //加载字体颜色
    [self themeDidChangeNotification:nil];
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        [_weiboModel release];
        _weiboModel = [weiboModel retain];
    }
    
    //3.创建原微博视图
    if (_sourceWeiboView == nil && weiboModel.reWeibo != nil) {
        _sourceWeiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
        //设置此视图为原微博
        _sourceWeiboView.isSource = YES;
        _sourceWeiboView.isDetail = self.isDetail;
        [self addSubview:_sourceWeiboView];        
    }
    
    if (_weiboModel.linkText == nil) { //为空的话，说明此微博没有替换解析超链接
        //解析超链接
        [self _parseLink];
    }
    
    //设置调用layoutSubviews
    [self setNeedsLayout];
}

- (void)_parseLink {
    NSString *text = [UIUtils parseLinkText:_weiboModel.text];
    
    //判断当前是否为原微博视图
    if (self.isSource) {
        //微博的作者昵称
        NSString *nickName = _weiboModel.user.screen_name;
        //中文编码
        NSString *encodeName = [nickName URLEncodedString];
        NSString *linkName = [NSString stringWithFormat:@"<a href='user://%@'>@%@: </a>",encodeName,nickName];
        
        //将作者、微博内容拼接
        NSString *weiboText = [NSString stringWithFormat:@"%@%@",linkName,text];
        
        _weiboModel.linkText = weiboText;
    } else {
        _weiboModel.linkText = text;
    }
}

- (void)_renderTextLabel {
    //(1).设置字体大小: 普通微博字体是14，原微博视图字体是：13
    float fontSize = [WeiboView getFontSize:self.isDetail isSource:self.isSource];
    _textLabel.font = [UIFont systemFontOfSize:fontSize];
    
    //(2).设置textLabel的frame
    _textLabel.frame = CGRectMake(0, 0, self.width, 0);
    if (self.isSource) {
        _textLabel.frame = CGRectMake(10, 10, self.width-20, 0);
    }
    _textLabel.text = _weiboModel.linkText;//_weiboModel.text;
    CGSize textSize = _textLabel.optimumSize;  //获取计算之后的高度尺寸
    _textLabel.height = textSize.height;  //设置label的高度
}

- (void)_renderImage {
    //微博视图在列表显示
    if (!self.isDetail) {
        
        int browMode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (browMode == 0) {
            browMode = kSmalModel;
        }
        
        if (browMode == kSmalModel) {  //小图浏览模式
            //微博图片的url
            NSString *thumbnailImage = _weiboModel.thumbnailImage;
            if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
                _imageView.hidden = NO;
                //加载图片数据
                [_imageView setImageWithURL:[NSURL URLWithString:thumbnailImage]];
                _imageView.frame = CGRectMake(10, _textLabel.bottom+10, 70, kImgHeigh);
            } else {
                _imageView.hidden = YES;
            }
        }
        else if(browMode == kLargeModel) {  //大图浏览模式
            NSString *bmiddlelImage = _weiboModel.bmiddlelImage;
            if (bmiddlelImage != nil && ![@"" isEqualToString:bmiddlelImage]) {
                _imageView.hidden = NO;
                //加载图片数据
                [_imageView setImageWithURL:[NSURL URLWithString:bmiddlelImage]];
                _imageView.frame = CGRectMake(10, _textLabel.bottom+10, self.width-20, kImgHeigh_Larg);
            } else {
                _imageView.hidden = YES;
            }
        }
        else if(browMode == kNoneModel) {
            _imageView.hidden = YES;
        }
    }
    else { //微博视图在详情页面显示
        //微博图片的url
        NSString *bmiddlelImage = _weiboModel.bmiddlelImage;
        if (bmiddlelImage != nil && ![@"" isEqualToString:bmiddlelImage]) {
            _imageView.hidden = NO;
            //加载图片数据
            [_imageView setImageWithURL:[NSURL URLWithString:bmiddlelImage]];
            _imageView.frame = CGRectMake(10, _textLabel.bottom+10, self.width-20, kImgHeigh_detail);
        } else {
            _imageView.hidden = YES;
        }
    }
    
    //判断图片格式是否为gif
    //给微博图片添加放大功能
    NSString *originalImage = _weiboModel.originalImage;
    [_imageView addZoom:originalImage];
    
    NSString *extension = [originalImage pathExtension];
    UIImageView *gifIcon = (UIImageView *)[_imageView viewWithTag:2013];
    if ([extension isEqualToString:@"gif"]) {
        _imageView.isGif = YES;
        gifIcon.hidden = NO;
        gifIcon.frame = CGRectMake(_imageView.width-24, _imageView.height-15, 24, 15);
    } else {
        _imageView.isGif = NO;
        gifIcon.hidden = YES;
    }
    
}

- (void)_renderSourceWeibo {
    //原微博model
    WeiboModel *sourceWeibo = _weiboModel.reWeibo;
    if (sourceWeibo != nil) {
        _sourceWeiboView.hidden = NO;
        
        _sourceWeiboView.weiboModel = sourceWeibo;
        //计算原微博视图的高度
        float h = [WeiboView getWeiboViewHeight:sourceWeibo isSource:YES isDetail:self.isDetail];
        _sourceWeiboView.frame = CGRectMake(0, _textLabel.bottom, self.width, h);
    } else {
        _sourceWeiboView.hidden = YES;
    }
}

/*
 1.展示数据
 2.布局子视图
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    /*______________________________1.textLabel子视图_______________________________*/
    [self _renderTextLabel];
    
    /*______________________________2.imageView子视图_______________________________*/
    [self _renderImage];
    
    /*__________________________3.sourceWeiboView原微博视图_______________________*/
    [self _renderSourceWeibo];
    
    /*__________________________4._sourceBackgroudView原微博背景__________________*/
    if (self.isSource) {
        _sourceBackgroudView.hidden = NO;
        _sourceBackgroudView.frame = self.bounds;
    } else {
        _sourceBackgroudView.hidden = YES;
    }
}

//获取字体大小
+ (float)getFontSize:(BOOL)isDetail isSource:(BOOL)isSource {
    float fontsize = 14.0f;
    
    if (!isDetail) { //不是详情页面，在列表中的微博视图
        
        if (isSource) {
            fontsize = 15.0f;
        } else {
            fontsize = 16.0f;
        }
        
    } else { //在详情页面的微博视图
        
        if (isSource) {
            fontsize = 17.0f;
        } else {
            fontsize = 18.0f;
        }
        
    }
    
    return fontsize;
}

/*
 方法描述:计算微博视图的高度
    参数： weiboModel  微博model
          isSource    是否是原微博
 */
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                     isSource:(BOOL)isSource
                     isDetail:(BOOL)isDetail {
    
    if (weiboModel == nil) {
        return 0;
    }
    
    /*
      实现思路： 计算每个子视图的高度，然后相加
     */
    float height = 0;
    
    /*______________________1.计算textLabel的高度__________________________*/
    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectZero];
    
    float fontSize = [WeiboView getFontSize:isDetail isSource:isSource];
    rt.font = [UIFont systemFontOfSize:fontSize];
    
    float width = 0;
    if (isDetail) {
        width = kWeiboView_width_detail;
    } else {
        width = kWeiboView_width;
    }
    
    rt.width = width;
    NSString *text = weiboModel.text;
    if (isSource) { //判断是否是原微博视图
        rt.width = width-20;
        
        //如果是源微博,加上10的间隙
        height += 20;
        
        //拼接原微博的作者昵称
        NSString *nickName = weiboModel.user.screen_name;
        text = [NSString stringWithFormat:@"@%@: %@",nickName,text];
    }
    
    rt.text = [UIUtils parseLinkText:text];
    //textLabel的高度
    float textheight = rt.optimumSize.height;
    height += textheight;
    
    /*______________________2.计算微博图片的高度__________________________*/
    if (!isDetail) {
        int browMode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        if (browMode == 0) {
            browMode = kSmalModel;
        }
        
        if (browMode == kSmalModel) {
            NSString *thumbnailImage = weiboModel.thumbnailImage;
            if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
                height += (kImgHeigh+10);
            }
        } else if(browMode == kLargeModel) {
            NSString *bmiddlelImage = weiboModel.bmiddlelImage;
            if (bmiddlelImage != nil && ![@"" isEqualToString:bmiddlelImage]) {
                height += (kImgHeigh_Larg+10);
            }
        }
        //无图浏览模式不需要计算高度
    } else {
        NSString *bmiddlelImage = weiboModel.bmiddlelImage;
        if (bmiddlelImage != nil && ![@"" isEqualToString:bmiddlelImage]) {
            height += (kImgHeigh_detail+10);
        }        
    }
    
    /*______________________3.计算原微博视图高度__________________________*/
    //原微博对象
    WeiboModel *reWeibo = weiboModel.reWeibo;
    if (reWeibo != nil) {
        float reWeiboHeight = [WeiboView getWeiboViewHeight:reWeibo isSource:YES isDetail:isDetail];
        height += reWeiboHeight;
    }
    
    return height;
}

//主题更换事件
- (void)themeDidChangeNotification:(NSNotification *)notification {
    NSString *colorName = @"Timeline_Content_color";
    if (self.isSource) {
        colorName = @"Timeline_Retweet_color";
    }
    _textLabel.textColor = [[ThemeManager shareInstance] getThemeColor:colorName];
    
    //设置rtLabel的链接颜色
    NSString *linkColor = [[ThemeManager shareInstance] getLinkColor:@"Link_color"];
    WXLog(@"%@",linkColor);
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:linkColor forKey:@"color"];
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
}

#pragma mark - RTLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    [UIUtils didSelectLinkWithURL:url viewController:self.viewController];
}


@end
