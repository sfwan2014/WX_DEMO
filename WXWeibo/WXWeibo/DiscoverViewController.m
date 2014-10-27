//
//  DiscoverViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearWeiboMapController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"广场";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i=100; i<=101; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        //设置阴影的颜色
        button.layer.shadowColor = [UIColor blackColor].CGColor;
        //设置阴影的偏移量(大小)
        button.layer.shadowOffset = CGSizeMake(2, 2);
        //设置阴影的透明度
        button.layer.shadowOpacity = 1;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 100) {
        //附近的微博
        NearWeiboMapController *nearWeiboCtrl = [[NearWeiboMapController alloc] init];
        [self.navigationController pushViewController:nearWeiboCtrl animated:YES];
        [nearWeiboCtrl release];
    }
}

@end
