//
//  LaunchViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-9-10.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "LaunchViewController.h"
#import "MainTabbarController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        index = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UIImageView *bjView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //判断当前屏幕的高度，使用不同的图片
    NSString *imageName = (kScreenHeight==568) ? @"Default-568h@2x.png":@"Default.png";
    bjView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:bjView];
    [bjView release];
    
    //加载所有的图片
    [self _loadImageViews];

    [self showImage];
}

- (void)_loadImageViews {
    
    //单个图片的宽度
    int width = kScreenWidth/4;
    int height = (kScreenHeight==568)?kScreenHeight/7:kScreenHeight/6;
    
    //行数
    int row = kScreenHeight/height;
    //列数
    int colum = kScreenWidth/width;
    
    //图片的数量
    int count = row*colum;
    
    _imageArray = [[NSMutableArray alloc] initWithCapacity:count];
    
    int x = 0,y=0;
    
    for (int i=0; i<count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        NSString *imageName = [NSString stringWithFormat:@"%d@2x.png",(i+1)];
        imgView.image = [UIImage imageNamed:imageName];
        imgView.alpha = 0;
        [self.view addSubview:imgView];
        [imgView release];
        
        [_imageArray addObject:imgView];
        
        
        imgView.left = x;
        imgView.top = y;
        
        //计算下一张图片的x、y坐标
        //row=6
        if (i < 3) {
            x += width;
        } else if(i < row + 2) {
            y += height;
        } else if(i < row + 5) {
            x -= width;
        } else if(i < row*2 + 3) {
            y -= height;
        } else if(i < row*2 + 5) {
            x += width;
        } else if(i < row*3 + 2) {
            y += height;
        } else if(i< row*3 + 3) {
            x -= width;
        } else {
            y -= height;
        }
    }
    
}


- (void)showImage {
    
    if (index >= _imageArray.count) {
        [self showMain];
        
        //跳出递归
        return;
    }
    
    UIImageView *imgView = [_imageArray objectAtIndex:index];
    
    imgView.alpha = 0;
    [UIView beginAnimations:@"showView" context:nil];
    [UIView setAnimationDuration:0.15];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(showImage)];
    imgView.alpha = 1;
    [UIView commitAnimations];
    
    index++;
    
    //等动画结束之后，递归调用显示下一张图片
    [self performSelector:@selector(showImage) withObject:nil afterDelay:.15];
}

- (void)showMain {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.view.window.rootViewController = [[[MainTabbarController alloc] init] autorelease];
}


@end
