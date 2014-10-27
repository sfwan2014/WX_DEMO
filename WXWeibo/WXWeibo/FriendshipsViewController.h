//
//  FriendshipsViewController.h
//  WXWeibo
//
//  Created by wei.chen on 13-5-24.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "FirendshipsTableView.h"

//typedef enum{
//    Attention=100,  //关注列表
//    Fans        //粉丝列表
//}FriendshipsType;

typedef NS_ENUM(NSInteger, FriendshipsType) {
    Attention=100,  //关注列表
    Fans        //粉丝列表
};

@interface FriendshipsViewController : BaseViewController<BaseTableViewDelegate> {
    NSMutableArray *_data;
}

@property (retain, nonatomic) IBOutlet FirendshipsTableView *tableView;
//列表类型
@property(nonatomic,assign)FriendshipsType shipType;
@property(nonatomic,copy)NSString *userId;

@end
