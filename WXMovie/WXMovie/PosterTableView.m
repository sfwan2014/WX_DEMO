//
//  PosterTableView.m
//  WXMovie
//
//  Created by wei.chen on 13-8-31.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "PosterTableView.h"
#import "MovieModel.h"
#import "UIImageView+WebCache.h"
#import "MovieDetailView.h"

@implementation PosterTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"posterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //将cell.contentView顺时针旋转90度
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.rowHeight-20, self.height-10)];
        baseView.tag = 100;
        [cell.contentView addSubview:baseView];
        [baseView release];
        
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [baseView addGestureRecognizer:tap];
        [tap release];
        
        //详细视图
        MovieDetailView *detailView = [[MovieDetailView alloc] initWithFrame:baseView.bounds];
        detailView.tag = 400;
        [baseView addSubview:detailView];
        [detailView release];
        
        //显示海报图片视图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:baseView.bounds];
        imageView.backgroundColor = [UIColor grayColor];
        imageView.tag = 200;
        [baseView addSubview:imageView];
        [imageView release];
    } else {
        //cell复用时回转显示海报视图
        UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:200];
        [imageView.superview bringSubviewToFront:imageView];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:200];
    MovieModel *movie = [self.data objectAtIndex:indexPath.row];
    NSString *urlstring = [movie.images objectForKey:@"large"];
    [imageView setImageWithURL:[NSURL URLWithString:urlstring]];
    
    //将电影数据赋给详细视图
    MovieDetailView *detailView = (MovieDetailView *)[cell.contentView viewWithTag:400];
    detailView.movie = movie;
    //设置detailView在合适的时机去渲染layoutSubViews方法
    [detailView setNeedsLayout];
    
    return cell;
}

//单元格点击之后翻转
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    UITableViewCell *cell = (UITableViewCell *)tap.view.superview.superview;
    if (![cell isKindOfClass:[UITableViewCell class]]) {
        return;
    }
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    int row = indexPath.row;
    
//    CGPoint p = [tap locationInView:self];
////    NSLog(@"%f",p.y);
//    int row = p.y/self.rowHeight;
    
    if (row == self.selectedInexPath.row) {
        tap.enabled = NO;
        
        UIView *baseView = tap.view;
        
        UIViewAnimationTransition trasition = (baseView.tag == 100) ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:trasition forView:baseView cache:YES];
        
        [baseView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        
        [UIView commitAnimations];
        
        baseView.tag = (baseView.tag == 100) ? 300 : 100;
        
        [tap performSelector:@selector(setEnabled:) withObject:@YES afterDelay:0.5];
    } else {
        
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        self.selectedInexPath = indexPath;
    }
}

#pragma mark - override 覆写方法
//单元格移动到中间调用的方法
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
/*
  修复bug
 
 bug描述：
  图片移动到中间时，点击翻转，移动会停止
 解决思路：
  移动时，禁用触摸事件，从而禁止点击翻转
 */
//    self.userInteractionEnabled = NO;
    
    self.scrollEnabled = NO;
    
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    
    [self performSelector:@selector(setScrollEnabled:) withObject:@YES afterDelay:0.2];
}

@end
