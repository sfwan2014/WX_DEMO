//
//  PosterView.h
//  WXMovie
//
//  Created by wei.chen on 13-8-31.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PosterTableView;
@class IndexTableView;

/*
  海报视图
 */
@interface PosterView : UIView {
    
    //海报表视图
    PosterTableView *_posterTable;
    //海报索引表视图
    IndexTableView *_indexTableView;
    
    //尾部标题视图
    UILabel *_footerLabel;
    
    UIImageView *_headerView;
    UIButton *_arrowsButton;
    UIControl *_maskView;
    
    UISwipeGestureRecognizer *_swipe;
}

@property(nonatomic,retain)NSArray *data;

@end
