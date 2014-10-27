//
//  CinemaViewController.h
//  WXMovie
//
//  Created by wei.chen on 13-8-28.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface CinemaViewController : BaseViewController<EGORefreshTableHeaderDelegate> {
    
    //结构
    /*
     [
        {"name":"东城区","id":"1029"},
        ...
     ]
     */
    NSArray *districtArray;
    
    //结构
    /*
     {
        "1029" : [
           影院model1,
           影院model2,     
         ],
        ...
     }
     */
    NSMutableDictionary *cinemaData;
    
    //存储每一个组是否收起的状态
    /*
     [YES,NO,NO,....]     //YES:收起  NO：展开
     */
    BOOL close[30];
    
    EGORefreshTableHeaderView *_refreshView;
    BOOL _reloading;
}

@end
