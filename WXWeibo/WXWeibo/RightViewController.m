//
//  RightViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"
#import "UIViewController+MMDrawerController.h"
#import "SendViewController.h"
#import "WXNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self _initViews];
}

- (void)_initViews {
    NSArray *imgs = @[
                      @"newbar_icon_1.png",
                      @"newbar_icon_2.png",
                      @"newbar_icon_3.png",
                      @"newbar_icon_4.png",
                      @"newbar_icon_5.png",
                      @"newbar_icon_6.png"
                      ];
    NSArray *imgTitle = @[@"微博",@"拍照",@"相册",@"视频",@"多图",@"位置"];
    
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        NSString *title = imgTitle[i];
        
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(30, 30+(65*i), 40, 40)];
        button.tag = i;
        [button addTarget:self action:@selector(sendWeibo:) forControlEvents:UIControlEventTouchUpInside];
        button.imgName = imgName;
        [self.view addSubview:button];
        
        ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(button.left, button.bottom, 40, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.text = title;
        [self.view addSubview:label];
        
        [label release];
        [button release];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sendWeibo:(UIButton *)button {
    if (button.tag == 0) {
        SendViewController *sendCtrl = [[SendViewController alloc] init];
        WXNavigationController *navigation = [[WXNavigationController alloc] initWithRootViewController:sendCtrl];
        
        [self presentViewController:navigation animated:YES completion:NULL];
        
        [sendCtrl release];
        [navigation release];
    }
}

@end
