//
//  NearbyViewController.m
//  WXWeibo
//
//  Created by wei.chen on 13-5-27.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "NearbyViewController.h"
#import "UIImageView+WebCache.h"
#import "BaseCell.h"
#import "ThemeButton.h"

@interface NearbyViewController ()

@end

@implementation NearbyViewController

- (void)dealloc
{
    [_tableView release];    
    WXRelease(_selectedBlock);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我在这里";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.tableView.hidden = YES;
    [super showLoading:YES];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idenify = @"cell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:idenify];
    if (cell == nil) {
        cell = [[[BaseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idenify] autorelease];
    }
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = address;
    [cell.imageView setImageWithURL:[NSURL URLWithString:icon]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    //1.回调block
    if (self.selectedBlock != nil) {
        self.selectedBlock(dic);
    }
    
    //2.关闭窗口
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)afterLoadData:(NSDictionary *)result {
    NSArray *pois = [result objectForKey:@"pois"];
    self.data = pois;
    [super showLoading:NO];
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

#pragma mark - CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {

    //停止定位
    [manager stopUpdatingLocation];
    
    //没有数据才去请求网络
    if (self.data == nil) {
        float longitude = newLocation.coordinate.longitude;
        float latitude = newLocation.coordinate.latitude;
        
        NSString *longitudeString = [NSString stringWithFormat:@"%f",longitude];
        NSString *latitudeString = [NSString stringWithFormat:@"%f",latitude];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:longitudeString,@"long",latitudeString,@"lat", nil];
        
//        __block NearbyViewController *this = self;
//        SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"place/nearby/pois.json"
//                                params:params httpMethod:@"GET" block:^(id result) {
//                                    [this afterLoadData:result];
//                                }];
//        [self.requests addObject:request];
        
        __block NearbyViewController *this = self;
        [WXDataService requestWithURL:@"place/nearby/pois.json"
                               params:params httpMethod:@"GET" block:^(id result) {
                                   [this afterLoadData:result];
                               }];
        
    }
}

- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
