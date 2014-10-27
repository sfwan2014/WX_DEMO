//
//  IndexTableView.m
//  WXMovie
//
//  Created by wei.chen on 13-8-31.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "IndexTableView.h"
#import "MovieModel.h"
#import "UIImageView+WebCache.h"

@implementation IndexTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"posterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //将cell.contentView顺时针旋转90度
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.rowHeight-10, self.height-10)];
        imageView.backgroundColor = [UIColor grayColor];
        imageView.tag = 200;
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:200];
    
    MovieModel *movie = [self.data objectAtIndex:indexPath.row];
    NSString *urlstring = [movie.images objectForKey:@"medium"];
    
    [imageView setImageWithURL:[NSURL URLWithString:urlstring]];
    
    return cell;
}

@end
