//
//  TopCell.m
//  WXMovie
//
//  Created by wei.chen on 13-9-6.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "TopCell.h"
#import "TopGridView.h"

@implementation TopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)_initViews {
    //去掉选中效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _gridViews = [[NSMutableArray alloc] init];
    
    //创建gridView
    for (int i=0; i<3; i++) {
        TopGridView *gridView = [[TopGridView alloc] initWithFrame:CGRectZero];
        [_gridViews addObject:gridView];
        [self.contentView addSubview:gridView];
        [gridView release];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i=0; i<3; i++) {
        TopGridView *gridView = [_gridViews objectAtIndex:i];
        gridView.frame = CGRectMake(10+i*(90+15), 10, 90, 140);
        
        if (i < self.data.count) {
            gridView.hidden = NO;
            gridView.movie = self.data[i];
        } else {
            gridView.hidden = YES;
        }
    }
}

@end
