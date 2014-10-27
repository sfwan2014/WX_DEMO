//
//  PosterView.m
//  WXMovie
//
//  Created by wei.chen on 13-8-31.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "PosterView.h"
#import "PosterTableView.h"
#import "IndexTableView.h"
#import "MovieModel.h"

#define kHeaderViewHeight 100
#define kFooterViewHeight 35

@implementation PosterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        //创建头部视图
        [self _initHeaderView];
        
        //创建海报表视图
        [self _initPosterTableView];
        
        //创建海报索引视图
        [self _initIndexPosterTableView];
        
        //创建灯光视图
        [self _initLightView];
        
        //创建尾部视图，显示电影标题
        [self _initFooterView];
        
        //将视图_headerView放最上面显示
        [self bringSubviewToFront:_headerView];
        
        //添加向下轻扫手势
        _swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
        [self addGestureRecognizer:_swipe];
        _swipe.direction = UISwipeGestureRecognizerDirectionDown;
        
        //KVO观察PosterTableView 、 IndexTableView 两个对象的selectedInexPath 属性变化
        [_posterTable addObserver:self forKeyPath:@"selectedInexPath" options:NSKeyValueObservingOptionNew context:NULL];
        
        [_indexTableView addObserver:self forKeyPath:@"selectedInexPath" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    return self;
}

- (void)setData:(NSArray *)data {
    if (_data != data) {
        [_data release];
        _data = [data retain];
    }
    
    _posterTable.data = data;
    _indexTableView.data = data;
    
    [_indexTableView reloadData];
    [_posterTable reloadData];
    
    
    //显示第一个电影标题
    if (data.count > 0) {
        MovieModel *movie = [data objectAtIndex:0];
        _footerLabel.text = movie.title;
    }

}

#pragma mark - KVO 观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"selectedInexPath"]) {
        //最新的indexPath
        NSIndexPath *indexPath = [change objectForKey:@"new"];
        
        if (object == _posterTable &&
            indexPath.row != _indexTableView.selectedInexPath.row) { //被观察的对象是海报视图
            
            _indexTableView.selectedInexPath = indexPath;
            
            [_indexTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
        else if(object == _indexTableView && indexPath.row != _posterTable.selectedInexPath.row) { //被观察的对象是索引视图
            
            _posterTable.selectedInexPath = indexPath;
            
            [_posterTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];            
        }

        //修改显示选中的电影标题
        MovieModel *movie = self.data[indexPath.row];
        _footerLabel.text = movie.title;
    }
}

#pragma mark - init UI 创建视图
//创建头部视图
- (void)_initHeaderView {
    //头部视图
     _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeaderViewHeight, kScreenWidth, kHeaderViewHeight+26)];
    //开启响应触摸事件
    _headerView.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"indexBG_home.png"];
    
//  UIImage *resizeImage = [image stretchableImageWithLeftCapWidth:0 topCapHeight:10]
    //设置图片拉伸的区域
    UIImage *resizeImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    _headerView.image = resizeImage;
    [self addSubview:_headerView];
    
    //下拉箭头按钮
    _arrowsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_arrowsButton setImage:[UIImage imageNamed:@"down_home@2x.png"]
                  forState:UIControlStateNormal];
    [_arrowsButton setImage:[UIImage imageNamed:@"up_home@2x.png"]
                  forState:UIControlStateSelected];
    _arrowsButton.frame = CGRectMake((kScreenWidth-15)/2, kHeaderViewHeight+8, 15, 15);
    [_arrowsButton addTarget:self action:@selector(arrowsButtonAction:)
           forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_arrowsButton];
}

//创建海报表视图
- (void)_initPosterTableView {
    _posterTable = [[PosterTableView alloc]
                                    initWithFrame:CGRectMake(0, 26, kScreenWidth, self.height-26-kFooterViewHeight)
                                    style:UITableViewStylePlain];
    _posterTable.rowHeight = 240;
    [self addSubview:_posterTable];
}

//创建海报索引视图
- (void)_initIndexPosterTableView {
    _indexTableView = [[IndexTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight) style:UITableViewStylePlain];
    _indexTableView.rowHeight = 75;
    [_headerView addSubview:_indexTableView];
    
}

//创建灯光视图
- (void)_initLightView {
    UIImage *image = [UIImage imageNamed:@"light.png"];
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithImage:image];
    leftImgView.frame = CGRectMake(18, 0, 124, 204);
    [self addSubview:leftImgView];

    UIImageView *rightImgView = [[UIImageView alloc] initWithImage:image];
    rightImgView.frame = CGRectMake(self.width-124-18, 0, 124, 204);
    [self addSubview:rightImgView];
    
    [leftImgView release];
    [rightImgView release];
}

//创建尾部视图，显示电影标题
- (void)_initFooterView {
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bottom-kFooterViewHeight, kScreenWidth, kFooterViewHeight)];
    _footerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"poster_title_home.png"]];
    _footerLabel.font = [UIFont boldSystemFontOfSize:16];
    _footerLabel.textColor = kThemeColor;
    _footerLabel.text = @"无限电影";
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_footerLabel];
}

- (void)_initMaskView {
    if (_maskView == nil) {
        _maskView = [[UIControl alloc] initWithFrame:self.bounds];
        [_maskView addTarget:self action:@selector(maskViewAction:) forControlEvents:UIControlEventTouchUpInside];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self insertSubview:_maskView belowSubview:_headerView];
    }
}

#pragma mark - Actions 事件方法
- (void)arrowsButtonAction:(UIButton *)button {
    if (button.selected) {
        //隐藏
        [self _hideIndexTableView];
    } else {
        //显示
        [self _showIndexTableView];
    }
}

- (void)maskViewAction:(UIControl *)maskView {
    //隐藏索引视图
    [self _hideIndexTableView];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    [self _showIndexTableView];
}

//显示索引视图
- (void)_showIndexTableView {
    [self _initMaskView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.4];
    
    //显示
    _headerView.top += kHeaderViewHeight;
    _maskView.hidden = NO;
    _swipe.enabled = NO;
    _arrowsButton.selected = !_arrowsButton.selected;
    
    [UIView commitAnimations];
}

- (void)_hideIndexTableView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.4];
    
    //隐藏
    _headerView.top -= kHeaderViewHeight;
    _maskView.hidden = YES;
    _swipe.enabled = YES;
    _arrowsButton.selected = !_arrowsButton.selected;
    
    [UIView commitAnimations];
}

@end
