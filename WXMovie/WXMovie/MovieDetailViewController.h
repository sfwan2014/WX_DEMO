//
//  MovieDetailViewController.h
//  WXMovie
//
//  Created by wei.chen on 13-9-6.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"

@interface MovieDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_data;
}

@property(nonatomic,copy)NSString *movieId;

#pragma mark - Views
@property (retain, nonatomic) IBOutlet UIImageView *movieImageView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *tableHeaderView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *directorLabel;
@property (retain, nonatomic) IBOutlet UILabel *actorLabel;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) IBOutlet UIView *imageView;
@property (retain, nonatomic) IBOutlet UIImageView *img1View;
@property (retain, nonatomic) IBOutlet UIImageView *img2View;
@property (retain, nonatomic) IBOutlet UIImageView *img3View;
@property (retain, nonatomic) IBOutlet UIImageView *img4View;

- (IBAction)playAction:(UITapGestureRecognizer *)sender;

@end
