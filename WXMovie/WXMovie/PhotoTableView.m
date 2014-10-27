//
//  PhotoTableView.m
//  WXMovie
//
//  Created by wei.chen on 13-9-4.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "PhotoTableView.h"
#import "UIImageView+WebCache.h"
#import "PhotoScrollView.h"

@implementation PhotoTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.pagingEnabled = YES;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"posterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //将cell.contentView顺时针旋转90度
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.contentView.backgroundColor = [UIColor blackColor];
        
        
        PhotoScrollView *photoSV = [[PhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        photoSV.tag = 100;
        [cell.contentView addSubview:photoSV];
        
        photoSV.tableView = self;
    }
    
    PhotoScrollView *photoSV = (PhotoScrollView *)[cell.contentView viewWithTag:100];
    NSString *urlstring = [self.data objectAtIndex:indexPath.row];
    photoSV.url = [NSURL URLWithString:urlstring];
    photoSV.row = indexPath.row;
    
    return cell;
}

@end
