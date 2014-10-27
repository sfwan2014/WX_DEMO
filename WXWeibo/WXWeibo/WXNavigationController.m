//
//  WXNavigationController.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-13.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXNavigationController.h"
#import "ThemeManager.h"

#define KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

/////////////////////////////////////////////////////////////////////////////
#pragma mark - WXNavigationBar 子类化UINavigationBar
@interface WXNavigationBar : UINavigationBar
@end
@implementation WXNavigationBar
//禁用导航栏的pop动画
- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated {
    return [super popNavigationItemAnimated:NO];
}
@end

@interface WXNavigationController (){
    CGPoint startTouch;
    BOOL isMoving;
    
    UIImageView *backImageView;
    UIView *alphaView;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *backImages;

@end

@implementation WXNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeDidChangeNofitication object:nil];
        
        self.backImages = [[[NSMutableArray alloc]initWithCapacity:2]autorelease];
        self.canDragBack = YES;        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //1.创建自定义导航栏对象
    WXNavigationBar *navigationBar = [[WXNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self setValue:navigationBar forKey:@"navigationBar"];
    [navigationBar release];
    
    //2.创建滑动手势,实现左右滑动视图
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_pan setEnabled:NO];
    [self.view addGestureRecognizer:_pan];
    
    //3.设置导航栏的背景
    [self loadImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)themeChangeAction:(NSNotification *)notification {
    [self loadImage];
}

- (void)loadImage {
//    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"mask_titlebar.png"];
//    //1.设置导航栏的背景
//    [self.navigationBar setBackgroundImage:image
//                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
    
    
    //2.设置标题字体
    UIColor *titleColor = [[ThemeManager shareInstance] getThemeColor:@"Mask_Title_color"];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              titleColor,UITextAttributeTextColor,
                                              [UIFont boldSystemFontOfSize:18],UITextAttributeFont,
                                              nil];
    
    UIImage *bjImg = [[ThemeManager shareInstance] getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bjImg];    
}


//////////////////////////////抽屉式导航////////////////////////////////////////

- (void)pan:(UIPanGestureRecognizer *)pan {
    //手势开始
    if (pan.state == UIGestureRecognizerStateBegan) {
        if (self.viewControllers.count <= 1 || !self.canDragBack) {
            return;
        }
        
        isMoving = NO;
        startTouch = [pan locationInView:KEY_WINDOW];
    }
    else if(pan.state == UIGestureRecognizerStateChanged) {
        if (self.viewControllers.count <= 1 || !self.canDragBack) {
            return;
        }
        
        CGPoint moveTouch = [pan locationInView:KEY_WINDOW];
        
        if (!isMoving && moveTouch.x-startTouch.x > 10) {
            backImageView.image = [self.backImages lastObject];
            isMoving = YES;
        }
        
        [self moveViewWithX:moveTouch.x - startTouch.x];
    
    }
    else if(pan.state == UIGestureRecognizerStateEnded) {
        if (self.viewControllers.count <= 1 || !self.canDragBack) {
            return;
        }
        
        CGPoint endTouch = [pan locationInView:KEY_WINDOW];
        
        if (endTouch.x - startTouch.x > 50) {
            animationTime =.35 - (endTouch.x - startTouch.x) / kScreenWidth * .35;
            [self popViewControllerAnimated:NO];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                isMoving = NO;
            }];
            
        }
    }
    else if(pan.state == UIGestureRecognizerStateCancelled) {
        if (self.viewControllers.count <= 1 || !self.canDragBack) {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            isMoving = NO;
        }];
    }
}

#pragma mark - override UINavigationController方法覆写
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIImage *capture = [self capture];
    if (capture != nil) {
        [self.backImages addObject:capture];
    }
    
    if (self.viewControllers.count == 1) {
        [_pan setEnabled:YES];
    }
    
    [super pushViewController:viewController animated:NO];
    
    if (self.backgroundView == nil) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundView = [[[UIView alloc]initWithFrame:frame] autorelease];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        
        backImageView = [[UIImageView alloc] initWithFrame:frame];
        [self.backgroundView addSubview:backImageView];
        NSLog(@"%@",NSStringFromCGRect(self.view.bounds) );
        alphaView = [[UIView alloc] initWithFrame:frame];
        alphaView.backgroundColor = [UIColor blackColor];
        [self.backgroundView addSubview:alphaView];
    }
    if (self.backgroundView.superview == nil) {
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
    }
    
    if (self.viewControllers.count == 1) {
        return;
    }
    
    backImageView.image = [self.backImages lastObject];
    alphaView.alpha = 0;
    
    [self moveViewWithX:320];
    [UIView animateWithDuration:.35 animations:^{
        [self moveViewWithX:0];
    }];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (animated == YES) {
        animationTime = .35;
    }
    if (self.viewControllers.count == 2) {
        [_pan setEnabled:NO];
    }
    
    if (self.view.frame.origin.x == 0) {
        backImageView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }
    [UIView animateWithDuration:animationTime animations:^{
        [self moveViewWithX:320];
    } completion:^(BOOL finished) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        frame.origin.x = 0;
        self.view.frame = frame;
        
        //先导航控制器，在移除图片
        [super popViewControllerAnimated:NO];
        
        [self.backImages removeLastObject];
        backImageView.image = [self.backImages lastObject];
        
        CFRunLoopStop(CFRunLoopGetCurrent());
    }];
    
    CFRunLoopRun();
    
    return nil;
}

#pragma mark - Utility Methods -
//获取当前屏幕视图的快照图片
- (UIImage *)capture {
    
    UIView *view = self.tabBarController.view;
    if (view == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"%f,%f",img.size.height,img.size.width);
    UIGraphicsEndImageContext();
    
    return img;
}

//移动导航控制器的根视图self.view
- (void)moveViewWithX:(float)x {
    
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    frame.origin.x = x;
    self.view.frame = frame;
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    backImageView.transform = CGAffineTransformMakeScale(scale, scale);
    alphaView.alpha = alpha;
}

@end
