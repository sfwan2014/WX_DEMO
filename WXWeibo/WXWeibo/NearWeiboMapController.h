//
//  NearWeiboMapController.h
//  WXWeibo
//
//  Created by wei.chen on 13-10-18.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface NearWeiboMapController : BaseViewController<MKMapViewDelegate> {
    CLLocationManager *_locationManager;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,retain)NSDictionary *data;

- (IBAction)backAction:(UIButton *)sender;

@end
