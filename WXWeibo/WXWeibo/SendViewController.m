//
//  SendViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-15.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeButton.h"
#import "MMDrawerController.h"
#import "NearbyViewController.h"
#import "WXNavigationController.h"
#import "ThemeImageView.h"
#import "ZoomImgeView.h"
#import "WXFaceScrollView.h"

@interface SendViewController ()<ZoomImageViewDelegate>

//选取的图片数据
@property(nonatomic,retain)UIImage *sendImg;

@end

@implementation SendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //监听键盘弹出的通知 UIKeyboardWillShowNotification
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(keyboardWillShowNotification:)
         name:UIKeyboardWillShowNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _editorButtons = [[NSMutableArray alloc] initWithCapacity:5];
    [self _loadNavigationViews];
    [self _loadEidtorViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data 

- (void)_sendWeiboData:(NSString *)text {
    
//    [super showHUD:@"正在发送..."];
    [super showStatusTip:@"正在发送..." show:YES];
    [self closeAction];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    
    //1.判断是否有位置数据
    if (self.locationData != nil) {
        //经度
        NSString *lon = [self.locationData objectForKey:@"lon"];
        NSString *lat = [self.locationData objectForKey:@"lat"];
        
        //添加经度、纬度数据
        [params setObject:lon forKey:@"long"];
        [params setObject:lat forKey:@"lat"];
    }
    
    //2.判断是否有图片数据
    NSString *urlstring = nil;
    if (self.sendImg == nil) {
        //不带图片
        urlstring = send_update;
    } else {
        //带图片
        urlstring = send_upload;
        
        //添加图片参数
        NSData *data = UIImageJPEGRepresentation(self.sendImg, 0.3);
        [params setObject:data forKey:@"pic"];
    }
    
    //3.发送请求
//    [self.sinaweibo requestWithURL:urlstring
//                            params:params httpMethod:@"POST" block:^(id result) {
//                                WXLog(@"%@",result);
////                                [super hideHUDWithComplete:@"发送成功!"];
//                                [super showStatusTip:@"发送成功" show:NO];
//                            }];
    
    __block SendViewController *this = self;
    [WXDataService requestWithURL:urlstring params:params httpMethod:@"POST" block:^(id result) {
        [this showStatusTip:@"发送成功" show:NO];
    }];
    
}

#pragma mark - Load Views
- (void)_loadNavigationViews {
    //1.关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.imgName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.leftBarButtonItem = closeItem;
    [closeItem release];
    [closeButton release];
    
    //2.发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.imgName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    self.navigationItem.rightBarButtonItem = sendItem;
    [sendButton release];
    [sendItem release];
    
    //3.导航标题
    self.title = @"发微博";
}

- (void)_loadEidtorViews {
    //1.创建输入视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;
    //弹出键盘
    [_textView becomeFirstResponder];
    [self.view addSubview:_textView];
    
    //2.创建编辑工具栏
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    _editorBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_editorBar];
    
    //3.创建编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_6.png",
                      @"compose_toolbar_5.png"                      
                    ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        button.imgName = imgName;
        [_editorBar addSubview:button];
        [button release];
        
        [_editorButtons addObject:button];
    }
}

#pragma mark - 按钮事件 actions
//关闭按钮事件
- (void)closeAction {

    [self dismissViewControllerAnimated:YES completion:^{
        
        //发微博窗口关闭之后，关闭右侧控制器
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if ([keyWindow.rootViewController isKindOfClass:[MMDrawerController class]]) {
            MMDrawerController *mmDrawer = (MMDrawerController *)keyWindow.rootViewController;
            [mmDrawer closeDrawerAnimated:YES completion:NULL];
        }
    }];
}

//发微博事件
- (void)sendAction {
    
    NSString *text = _textView.text;
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }
    else if(text.length > 140) {
        error = @"微博内容大于140字符";
    }
    
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;        
    }
    
    //发送微博
    [self _sendWeiboData:text];
    
}

//编辑工具栏按钮的点击事件
- (void)buttonAction:(UIButton *)button {
    if (button.tag == 14) { //定位
        [self location];
    }
    else if(button.tag == 10) { //发送图片
        [self selectImage];
    }
    else if(button.tag == 13) { //显示、隐藏表情
        
        BOOL isFirstResponder = [_textView isFirstResponder];
        //判断输入框是否为第一响应者，如果是的话说明已经弹出键盘了
        if(isFirstResponder) {
            [self showFaceView];
        } else {
            [self hideFaceView];
        }
        
    }
}

#pragma mark - 编辑操作
//定位
- (void)location {
    NearbyViewController *nearby = [[NearbyViewController alloc] init];
    nearby.isModalButton = YES;
    __block SendViewController *this = self;
    [nearby setSelectedBlock:^(NSDictionary *result){
        [this showLocation:result];
    }];
    
    WXNavigationController *navigation = [[WXNavigationController alloc] initWithRootViewController:nearby];
    
    [self presentViewController:navigation animated:YES completion:NULL];
    
    [nearby release];
    [navigation release];
}

- (void)showLocation:(NSDictionary *)result {
    self.locationData = result;
    
   ThemeImageView *locaionIcon = (ThemeImageView *)[_editorBar viewWithTag:100];
    if (locaionIcon == nil) {
        locaionIcon = [[ThemeImageView alloc] initWithFrame:CGRectMake(kScreenWidth-12-10, 5, 12, 12)];
        locaionIcon.imgName = @"timeline_item_address_icon.png";
        locaionIcon.tag = 100;
        [_editorBar addSubview:locaionIcon];
    }
    
    NSString *title = [result objectForKey:@"title"];
    NSString *text = _textView.text;
    text = [text stringByAppendingFormat:@"我在:#%@#",title];
    _textView.text = text;
}

//选取相册、拍照
- (void)selectImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

//移除选取的图片
- (void)removeImgAction {
    //1.缩小图片
    [_selectImg zoomOutAction];
    
    //2.移除图片
    [_selectImg removeFromSuperview];
    self.sendImg = nil;
    
    //3.移回编辑按钮
    for (int i=0; i<_editorButtons.count-1; i++) {
        UIButton *button = _editorButtons[i];
        //还原transform
        button.transform = CGAffineTransformIdentity;
    }
}

//显示表情、隐藏键盘
- (void)showFaceView {
    if (_faceView == nil) { //创建表情视图
        //self-->self.view-->_faceView--block-->self
        
        __block SendViewController *this = self;
        _faceView = [[WXFaceScrollView alloc] initWithBlock:^(NSString *faceName) {
            NSString *text = this->_textView.text;
            text = [text stringByAppendingString:faceName];
            this->_textView.text = text;
        }];
        
        _faceView.top = kScreenHeight-20-44;
        [self.view addSubview:_faceView];
    }
    
    //1.显示表情
    _faceView.top = kScreenHeight-20-44;
    [UIView animateWithDuration:0.3 animations:^{
        
        float y = _faceView.height;
        _faceView.transform = CGAffineTransformTranslate(_faceView.transform, 0, -y);
        
        
        //布局视图
        _textView.height = kScreenHeight-20-44-_editorBar.height-y;
        _editorBar.top = _textView.bottom;        
    }];
    
    //2.隐藏键盘
    [_textView resignFirstResponder];
}

//隐藏表情、显示键盘
- (void)hideFaceView {
    
    //1.隐藏表情
    [UIView animateWithDuration:0.3 animations:^{
        //还原transform
        _faceView.transform = CGAffineTransformIdentity;
    }];
    
    //2.显示键盘
    [_textView becomeFirstResponder];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType sourceType;
    //1.拍照
    if (buttonIndex == 0) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
        //判断是否有摄像头
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            //提示无摄像头
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
            return;
        }
    }
    //2.相册
    else if(buttonIndex == 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //3.取消
    else if(buttonIndex == 2) {
        return;
    }
    
    //弹出相册选取控制器
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    [imagePicker release];
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //1.关闭照片选取的窗口
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //2.显示照片的缩略图
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (_selectImg == nil) {
        _selectImg = [[ZoomImgeView alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
        _selectImg.delegate = self;
        _selectImg.layer.cornerRadius = 5;
        _selectImg.layer.masksToBounds = YES;
        [_selectImg addZoom:nil];
    }
    if (_selectImg.superview == nil) {
        [_editorBar addSubview:_selectImg];
    }
    
    _selectImg.image = image;
    
    //3.移动编辑按钮
    for (int i=0; i<_editorButtons.count-1; i++) {
        int x = 30 - i*5;
        UIButton *button = [_editorButtons objectAtIndex:i];
        button.transform = CGAffineTransformTranslate(button.transform, x, 0);
    }
    
    //4.图片数据
    self.sendImg = image;
}

#pragma mark - ZoomImageView Delegate
//将要放大图片
- (void)imageWillZoomIn:(UIView *)view {
    //收起键盘
    [_textView resignFirstResponder];
    
    //在放大图片上添加一个删除按钮
    ThemeButton *removeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(kScreenWidth-40-20, kScreenHeight-40-40, 40, 40)];
    removeButton.imgName = @"detail_button_delete.png";
    [removeButton addTarget:self action:@selector(removeImgAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:removeButton];
    [removeButton release];
}

//将要缩小图片
- (void)imageWillZoomOut:(UIView *)view {
    //弹出键盘
    [_textView becomeFirstResponder];
}


#pragma mark - NSNotification
//键盘弹出时调用的方法
- (void)keyboardWillShowNotification:(NSNotification *)notification {
    //    NSLog(@"%@",notification.userInfo);
    
    NSValue *sizeValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [sizeValue CGRectValue];
    
    //键盘的高度
    float height = CGRectGetHeight(frame);
    
    //布局视图
    _textView.height = kScreenHeight-20-44-_editorBar.height-height;
    _editorBar.top = _textView.bottom;
}

@end
