//
//  NearWeiboMapController.m
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NearWeiboMapController.h"
#import "WeiboModel.h"
#import <CoreLocation/CoreLocation.h>
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

@interface NearWeiboMapController ()<CLLocationManagerDelegate>

@end

@implementation NearWeiboMapController {
    int n;
}

- (void)dealloc {
    [_locationManager release];
    [_mapView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    //定位
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //显示导航栏
    [self.navigationController.navigationBar setHidden:NO];
}

//请求附近的微博
- (void)_loadNearWeiboData:(NSString *)lon latitude:(NSString *)lat {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:lon,@"long",lat,@"lat", nil];
    
    [WXDataService requestWithURL:nearby_timeline params:params httpMethod:@"GET" block:^(id result) {
        [self _afterLoadNearWeibo:result];
    }];
}

- (void)_afterLoadNearWeibo:(NSDictionary *)result {
    self.data = result;
    
    NSArray *statuses = [result objectForKey:@"statuses"];
    int i = 0;
    for (NSDictionary *weiboDic in statuses) {
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:weiboDic];
        
        //创建标注对象
        WeiboAnnotation *annotation = [[WeiboAnnotation alloc] initWithWeibo:weibo];
        [self.mapView addAnnotation:annotation];
        
//        [self.mapView performSelector:@selector(addAnnotation:) withObject:annotation afterDelay:0.5*i];
        
        [weibo release];
        [annotation release];
        
        i++;
    }
    
    
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - MKMapView delegate
//获取标注视图的协议方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identify = @"WeiboAnnotationView";
    WeiboAnnotationView *annotationView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identify];
    if (annotationView == nil) {
        annotationView = [[[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identify] autorelease];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    for (int i=0; i<views.count; i++) {
        UIView *annotationView = [views objectAtIndex:i];
        
        //动画1的尺寸：0.7 ---- 1.2
        //动画2的尺寸：1.2 ---- 1
        
        CGAffineTransform transform = annotationView.transform;
        annotationView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
        annotationView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            
            //设置延迟调用 1 /1.5/ 2
            [UIView setAnimationDelay:n*0.1];
            
            //动画1
            annotationView.transform = CGAffineTransformScale(transform, 1.2, 1.2);
            annotationView.alpha = 1;
            
        } completion:^(BOOL finished) {
            if (finished) {
                //动画2
                [UIView animateWithDuration:0.3 animations:^{
                    annotationView.transform = CGAffineTransformIdentity;
                }];
            }
        }];
    }
    
    n++;
    
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    //1.停止定位
    [manager stopUpdatingLocation];
    
    //2.设置地图的显示区域
    CLLocationCoordinate2D center = newLocation.coordinate;
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    [self.mapView setRegion:region];
    
    //3.请求数据
    if (self.data == nil) {
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
        [self _loadNearWeiboData:lon latitude:lat];
    }
    
}

@end
