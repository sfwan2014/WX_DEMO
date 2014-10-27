//
//  WXFaceView.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-16.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXFaceView.h"

#define item_width  45  //单个表情占用的区域宽度
#define item_height 45  //单个表情占用的区域高度

#define face_width  30  //单个表情图片的宽度
#define face_height 30  //单个表情图片的高度

@implementation WXFaceView

- (void)dealloc
{
    WXRelease(_items);
    WXRelease(_magnifierView);
    WXRelease(_selectedFaceName);
    WXRelease(_block);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initData];
    }
    return self;
}

- (void)_initData {
    
    _items = [[NSMutableArray alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    //整理成二维数组
    NSMutableArray *item2D = nil;
    for (int i=0; i<emoticons.count; i++) {
        if (item2D.count == 28 || item2D == nil) {
            item2D = [[NSMutableArray alloc] initWithCapacity:28];
            [_items addObject:item2D];
            [item2D release];
        }
        
        NSDictionary *item = [emoticons objectAtIndex:i];
        [item2D addObject:item];
    }
    
    //设置当前视图的宽度
    self.width = _items.count * kScreenWidth;
    self.height = item_height * 4;
    
    //设置页数
    self.pageNumber = _items.count;
    
    //创建放大镜视图
    _magnifierView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 92)];
    _magnifierView.hidden = YES;
    _magnifierView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
    _magnifierView.backgroundColor = [UIColor clearColor];
    [self addSubview:_magnifierView];
    
    //放大镜上的表情视图
    UIImageView *faceItem = [[UIImageView alloc] initWithFrame:CGRectMake((_magnifierView.width-face_width)/2, 15, face_width, face_height)];
    faceItem.backgroundColor = [UIColor clearColor];
    faceItem.tag = 2013;
    [_magnifierView addSubview:faceItem];
    
}

//绘制表情
- (void)drawRect:(CGRect)rect {
    
    //定义列数、行数
    int row = 0,colum = 0;
    
    for (int i=0; i<_items.count; i++) {
        
        NSArray *item2D = [_items objectAtIndex:i];
        
        for (int j=0; j<item2D.count; j++) {
            NSDictionary *item = [item2D objectAtIndex:j];
            //1.取得图片名
            NSString *imgName = [item objectForKey:@"png"];
            UIImage *image = [UIImage imageNamed:imgName];
            
            /*
             2.计算坐标
             通过colum计算出x坐标，colum --> x
             通过row计算出y坐标，  row --> y
             */
            float x = colum*item_width+(item_width-face_width)/2 + (i*kScreenWidth);
            float y = row*item_height + (item_height-face_height)/2;
            CGRect frame = CGRectMake(x, y, face_width, face_width);
            
            //3.绘制表情图片
            [image drawInRect:frame];
            
            
            //4.更新列与行
            colum++;
            if (colum % 7 == 0) {
                colum = 0;
                row++;
            }
            if (row == 4) {
                row = 0;
            }
        }
        
    }
    
}

//2.计算坐标
//通过colum计算出x坐标，colum --> x
//通过row计算出y坐标，  row --> y
//
//float x = colum*item_width+(item_width-face_width)/2 + (i*kScreenWidth);
//float y = row*item_height + (item_height-face_height)/2;
- (void)touchFace:(CGPoint)point {
    //1.计算页数
    int page = point.x / kScreenWidth;
    if (page >= _items.count) {
        return;
    }
    
    //2.计算行row、列colum
    int colum = (point.x-(item_width-face_width)/2 - (page*kScreenWidth))/item_width;
    int row = (point.y - (item_height-face_height)/2) / item_height;
    
    //3.范围处理
    /*
     colum范围：0-6
     row范围： 0-3
     */
    if(colum > 6) colum = 6;
    if(colum < 0) colum = 0;
    if(row > 3) row = 3;
    if(row < 0) row = 0;

    //4.通过colum、row计算触摸的表情在数组中的索引
    int index = colum + row * 7;
    NSArray *items2D = [_items objectAtIndex:page];
    if (index >= items2D.count) {
        return;
    }
    
    //5.取得表情
    NSDictionary *item = [items2D objectAtIndex:index];
    //表情名
    NSString *faceName = [item objectForKey:@"chs"];
    //图片名
    NSString *imgName = [item objectForKey:@"png"];
    
    //6.放大镜显示选中的表情
    if (![self.selectedFaceName isEqualToString:faceName]) {
        WXLog(@"face=%@,img=%@",faceName,imgName);        
        UIImage *image = [UIImage imageNamed:imgName];
        UIImageView *faceItem = (UIImageView *)[_magnifierView viewWithTag:2013];
        faceItem.image = image;
        
        //取得选中表情的中心区域的x\y坐标
        float x = colum*item_width + item_width/2 + page*kScreenWidth;
        float y = row*item_height + item_height/2;
        _magnifierView.center = CGPointMake(x, 0);
        _magnifierView.bottom = y;
        
        //记录当前选中的表情名
        self.selectedFaceName = faceName;
    }
}

#pragma mark - touch method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //显示放大镜
    _magnifierView.hidden = NO;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        //禁用滑动视图的滚动
        scrollView.scrollEnabled = NO;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //隐藏放大镜
    _magnifierView.hidden = YES;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        //禁用滑动视图的滚动
        scrollView.scrollEnabled = YES;
    }
    
    //回调block
    if (self.block != nil) {
        self.block(_selectedFaceName);
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        //禁用滑动视图的滚动
        scrollView.scrollEnabled = YES;
    }
    
    //隐藏放大镜
    _magnifierView.hidden = YES;    
}

@end
