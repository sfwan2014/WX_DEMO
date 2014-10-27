//
//  MovieDetailViewController.m
//  WXMovie
//
//  Created by wei.chen on 13-9-6.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieDetailModel.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "CommentModel.h"
#import "CommentCell.h"
#import "MoviePlayerViewController.h"
#import "WXNavigationController.h"

@interface MovieDetailViewController ()

@property(nonatomic,retain)NSIndexPath *selectIndexPath;

@end

@implementation MovieDetailViewController {
    MovieDetailModel *_movieDetail;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"电影详情";
        _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_main@2x.png"]];
    self.tableView.hidden = YES;
    
    [super showHUD:@"正在加载..."];
    //加载电影详情数据
    [self performSelector:@selector(loadRequestData) withObject:nil afterDelay:2];
    
    //加载评论数据
    [self performSelector:@selector(loadCommentData) withObject:nil afterDelay:2];    
}

//加载电影详情的数据
- (void)loadRequestData {
    [super hideHUD];
    
    self.tableView.hidden = NO;
    
    NSDictionary *movieDic = [WXDataService requestData:movie_detail];
    _movieDetail = [[MovieDetailModel alloc] initContentWithDic:movieDic];
    //刷新视图，显示数据
    [self refreshUI:_movieDetail];
}

- (void)loadCommentData {
    NSDictionary *jsonData = [WXDataService requestData:movie_comment];
    NSArray *list = [jsonData objectForKey:@"list"];
    
    for (NSDictionary *commentDic in list) {
        CommentModel *cm = [[CommentModel alloc] initContentWithDic:commentDic];
        [_data addObject:cm];
        [cm release];
    }
    
    [self.tableView reloadData];
}

//刷新UI
- (void)refreshUI:(MovieDetailModel *)movieDetail {
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    NSString *urlstring = movieDetail.image;
    [self.movieImageView setImageWithURL:[NSURL URLWithString:urlstring]];
    
    self.titleLabel.text = movieDetail.titleCn;
    NSString *dirctors = [movieDetail.directors componentsJoinedByString:@","];
    NSString *actors = [movieDetail.actors componentsJoinedByString:@","];
    NSString *types = [movieDetail.type componentsJoinedByString:@","];
    NSString *release = [[movieDetail.release allValues] componentsJoinedByString:@" "];
    
    self.directorLabel.text = [NSString stringWithFormat:@"导演: %@",dirctors];
    self.actorLabel.text = [NSString stringWithFormat:@"主演: %@",actors];
    self.typeLabel.text =[NSString stringWithFormat:@"类型: %@",types];
    self.timeLabel.text = release;
    
    //设置边框
    self.imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.imageView.layer.borderWidth = 1;
    //设置圆角的半径
    self.imageView.layer.cornerRadius = 5.0;
    
    [self.img1View setImageWithURL:[NSURL URLWithString:[movieDetail.images objectAtIndex:0]]];
    [self.img2View setImageWithURL:[NSURL URLWithString:[movieDetail.images objectAtIndex:1]]];
    [self.img3View setImageWithURL:[NSURL URLWithString:[movieDetail.images objectAtIndex:2]]];
    [self.img4View setImageWithURL:[NSURL URLWithString:[movieDetail.images objectAtIndex:3]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_tableView release];
    [_tableHeaderView release];
    [_titleLabel release];
    [_directorLabel release];
    [_actorLabel release];
    [_typeLabel release];
    [_timeLabel release];
    [_img1View release];
    [_img2View release];
    [_img3View release];
    [_img4View release];
    [_movieImageView release];
    [super dealloc];
}

- (IBAction)playAction:(UITapGestureRecognizer *)sender {
    
    if (_movieDetail.videos.count > 0) {
        MoviePlayerViewController *playerCtrl = [[MoviePlayerViewController alloc] initWithNibName:nil bundle:nil];
        WXNavigationController *navigation = [[WXNavigationController alloc] initWithRootViewController:playerCtrl];
        
        NSString *videourl = [[_movieDetail.videos objectAtIndex:0] objectForKey:@"url"];
        playerCtrl.movieUrl = [NSURL URLWithString:videourl];
        playerCtrl.movieTitle = _movieDetail.titleCn;
        playerCtrl.title = _movieDetail.titleCn;
        playerCtrl.isModalButton = YES;
        
        [self presentViewController:navigation animated:YES completion:NULL];
        
        [playerCtrl release];
        [navigation release];
    }
    
}

#pragma mark - DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"commentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        //加载xib
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
    }
    
    cell.commentModel = [_data objectAtIndex:indexPath.row];
    
    return cell;
    
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.selectIndexPath.row && self.selectIndexPath != nil) {
        
        CommentModel *cm = [_data objectAtIndex:indexPath.row];
        NSString *content = cm.content;

        //计算选中cell的高度
        float cellHeight = [CommentCell cellHeight:content];
        
        return cellHeight;
    }
    
    
    return 60;
}

//选中单元格的事件协议方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectIndexPath = indexPath;
    
    //刷新所有单元格
//    [tableView reloadData];
    //刷新多个组
//    [tableView reloadSections:<#(NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>];
    
    //刷新指定的多个单元格
    NSArray *indexPaths = @[indexPath];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

@end
