//
//  LoginViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController {
    
    IBOutlet UITextField *_userField;
    IBOutlet UITextField *_passField;
}

- (IBAction)loginAction:(UIButton *)sender;
@end
