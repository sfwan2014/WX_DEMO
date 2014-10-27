//
//  WXFaceScrollView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-16.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXFaceScrollView.h"

@implementation WXFaceScrollView

- (void)dealloc
{
    WXRelease(_scrollView);
    WXRelease(_faceView);
    WXRelease(_pageControll);    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (id)initWithBlock:(SelectedBlock)block {
    self =  [self initWithFrame:CGRectZero];
    if (self != nil) {
        _faceView.block = block;
    }
    return self;
}

- (void)setBlock:(SelectedBlock)block {
    _faceView.block = block;
}

- (void)_initViews {
    _faceView = [[WXFaceView alloc] initWithFrame:CGRectZero];
    _faceView.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(_faceView.width, _faceView.height);
    _scrollView.delegate = self;
    //子视图超出父视图部分不裁剪
    _scrollView.clipsToBounds = NO;
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    
    _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.bottom, kScreenWidth, 20)];
    _pageControll.backgroundColor = [UIColor clearColor];
    _pageControll.numberOfPages = _faceView.pageNumber;
    _pageControll.currentPage = 0;
    _pageControll.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_pageControll];
    
    self.height = _scrollView.height + _pageControll.height;
    self.width = _scrollView.width;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControll.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"emoticon_keyboard_background.png"] drawInRect:rect];
}

@end
