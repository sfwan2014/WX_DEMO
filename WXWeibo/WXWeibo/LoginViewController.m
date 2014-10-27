//
//  LoginViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.jpg"]];
    
    UIImage *backgroud = [UIImage imageNamed:@"login_inputbar.png"];
    backgroud = [backgroud stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    
    //设置输入框的背景
    _userField.background = backgroud;
    _passField.background = backgroud;
    
    [_userField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_userField release];
    [_passField release];
    [super dealloc];
}

- (IBAction)loginAction:(UIButton *)sender {
    
    NSString *username = _userField.text;
    NSString *password = _passField.text;
    
    if (username.length == 0 || password.length == 0) {
        return;
    }
    
    //1.收起键盘
    [_userField resignFirstResponder];
    [_passField resignFirstResponder];
    
    [super showWindowHUD:@"正在登陆..."];
    __block LoginViewController *this = self;
    
    
    //2.请求登陆
    [WXDataService requestLogin:username password:password block:^(id result) {
        NSLog(@"%@",result);
        
        [this hideHUD];
        [this afterLogin:result];
    }];
}

- (void)afterLogin:(NSDictionary *)result {
    NSString *error = [result objectForKey:@"error"];
    if (error != nil) {
        NSLog(@"登陆失败:%@",error);
        return;
    }
    
    //1.取得认证数据
    NSString *token = [result objectForKey:@"access_token"];
    NSString *expires_in = [result objectForKey:@"expires_in"];
    NSDate *expireDate = [NSDate dateWithTimeIntervalSinceNow:[expires_in doubleValue]];
    
    NSString *uid = [result objectForKey:@"uid"];
    
    //2.保存认证数据
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              token, @"AccessTokenKey",
                              expireDate, @"ExpirationDateKey",
                              uid, @"UserIDKey",nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //3.进入首页
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate loadMain];
}

@end
