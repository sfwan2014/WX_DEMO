//
//  ImageCell.m
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "ImageCell.h"
#import "UIButton+WebCache.h"
#import "ImageModel.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageDetailViewController.h"
#import "WXNavigationController.h"
#import "ImageListViewController.h"

@implementation ImageCell

- (void)dealloc {
    WXRelease(_buttonImages);
    WXRelease(_data);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //取消选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _buttonImages = [[NSMutableArray alloc] init];
        
        for (int i=0; i<4; i++) {
            UIButton *buttonImage = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置边框
            buttonImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
            buttonImage.layer.borderWidth = 1;
            buttonImage.backgroundColor = [UIColor blackColor];
            [buttonImage addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:buttonImage];
            
            [_buttonImages addObject:buttonImage];
        }
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i=0; i<_buttonImages.count; i++) { //0-3
        
        UIButton *buttonImage = [_buttonImages objectAtIndex:i];
        buttonImage.frame = CGRectMake(10+i*77, 5, 70, self.height-10);
        
        if (i < _data.count) {
            ImageModel *imageModel = [_data objectAtIndex:i];
            NSString *urlstring = imageModel.image;
            [buttonImage setImageWithURL:[NSURL URLWithString:urlstring]];
            
            //显示图片
            buttonImage.hidden = NO;
        } else { //没有数据
            
            //隐藏图片
            buttonImage.hidden = YES;
        }
    }
}

- (void)tapAction:(UIButton *)button {
    
    //查找出button的索引位置
    int buttonIndex = [_buttonImages indexOfObject:button];
    //取得选中的图片model
    ImageModel *clickImageModel = [_data objectAtIndex:buttonIndex];
    
    if ([self.viewController isKindOfClass:[ImageListViewController class]]) {
        ImageListViewController *imageList = (ImageListViewController *)self.viewController;
        
        //所有的图片model
        NSArray *imageArray = imageList.imageArray;
        //存储所有的图片url地址
        NSMutableArray *urls = [NSMutableArray arrayWithCapacity:imageArray.count];
        for (ImageModel *imageModel in imageArray) {
            NSString *urlstring = imageModel.image;
            [urls addObject:urlstring];
        }
        
        //查找点击的model，在所有图片model数组中的索引
        int index = [imageArray indexOfObject:clickImageModel];
        
        //创建图片浏览控制器
        ImageDetailViewController *imageDetail = [[ImageDetailViewController alloc] init];
        imageDetail.isModalButton = YES;
        imageDetail.data = urls;
        imageDetail.index = index;
        imageDetail.title = imageList.title;
        
        //创建导航控制器
        WXNavigationController *navigation = [[WXNavigationController alloc] initWithRootViewController:imageDetail];
        
        //     [self viewController];
        [self.viewController presentViewController:navigation animated:YES completion:NULL];
        
        [imageDetail release];
        [navigation release];
    }
}

@end
