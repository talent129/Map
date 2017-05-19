//
//  ViewController.m
//  地图
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *manager;//定位 请求用户授权

@property (nonatomic, strong) UIButton *centerBtn;

@property (nonatomic, strong) UIButton *zoomInBtn;//放大
@property (nonatomic, strong) UIButton *zoomOutBtn;//缩小

@end

@implementation ViewController

#pragma mark -
- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    }
    return _mapView;
}

- (UIButton *)centerBtn
{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerBtn.frame = CGRectMake(15, 100, 80, 30);
        [_centerBtn setTitle:@"中心位置" forState:UIControlStateNormal];
        [_centerBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(centerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}

- (UIButton *)zoomInBtn
{
    if (!_zoomInBtn) {
        _zoomInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zoomInBtn.frame = CGRectMake(15, 150, 80, 30);
        [_zoomInBtn setTitle:@"放大地图" forState:UIControlStateNormal];
        [_zoomInBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_zoomInBtn addTarget:self action:@selector(zoomInBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomInBtn;
}

- (UIButton *)zoomOutBtn
{
    if (!_zoomOutBtn) {
        _zoomOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zoomOutBtn.frame = CGRectMake(15, 200, 80, 30);
        [_zoomOutBtn setTitle:@"缩小地图" forState:UIControlStateNormal];
        [_zoomOutBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [_zoomOutBtn addTarget:self action:@selector(zoomOutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomOutBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.mapView];
    
    //1.创建位置管理器
    _manager = [[CLLocationManager alloc] init];
    //2.请求授权
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
    }
    
    //3.设置显示用户位置
    /*
     typedef NS_ENUM(NSInteger, MKUserTrackingMode) {
     MKUserTrackingModeNone = 0, // the user's location is not followed
     MKUserTrackingModeFollow, // the map follows the user's location
     MKUserTrackingModeFollowWithHeading __TVOS_PROHIBITED, // the map follows the user's location and heading
     } NS_ENUM_AVAILABLE(NA, 5_0) __TVOS_AVAILABLE(9_2) __WATCHOS_PROHIBITED;
     */
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //4.设置代理
    _mapView.delegate = self;
    
    //地图显示类型
//    _mapView.mapType =
    
    
    //按钮
    [self.mapView addSubview:self.centerBtn];
    
    [self.mapView addSubview:self.zoomOutBtn];
    [self.mapView addSubview:self.zoomInBtn];
    
    //iOS9新增属性
    //设置交通状况
    self.mapView.showsTraffic = YES;
    
    //设置指南针  默认YES  屏幕旋转后出现 点击会校正方向
    self.mapView.showsCompass = YES;
    
    //设置比例尺  显示在地图左上角
    self.mapView.showsScale = YES;
    
}

#pragma mark -MKMapViewDelegate
//更新用户位置
//MKUserLocation: 大头针模型
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"%@", userLocation.location);
    
//    userLocation.title = @"title";
//    userLocation.subtitle = @"subtitle";
    
    //通过MKUserLocation中的location属性 反地理编码 获取位置
    //创建一个Geocoder对象
    CLGeocoder *coder = [[CLGeocoder alloc] init];
    
    //反地理编码
    [coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //
        if (placemarks.count == 0 || error) {
            NSLog(@"错误");
            return ;
        }
        
        //获取对象 因为反地理编码 基本不存在重名问题  可不遍历
        CLPlacemark *mark = [placemarks lastObject];
        userLocation.title = mark.locality;//设置标题为城市信息
        userLocation.subtitle = mark.name;//设置子标题为详细信息
        
    }];
}

//设置用户中心位置
- (void)centerBtnAction
{
//    //设置中心点坐标  只能返回 但不能返回到之前地图大小  : 若缩小了地图 再移动位置  点击则能回到位置 但地图大小不能恢复
//    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    
    //设置范围属性
    //获取坐标
    CLLocationCoordinate2D coordinate = self.mapView.userLocation.location.coordinate;
    
    //设置显示范围
    MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
    
//    //设置范围属性  默认没有动画
//    self.mapView.region = MKCoordinateRegionMake(coordinate, span);
    
    //set 可以设置动画
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, span) animated:YES];
}

//代理方法 当地图显示区域发生改变后 调用的方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //获取默认显示大小 -->span
    NSLog(@"la: %f, long: %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
}

//放大地图
- (void)zoomInBtnAction
{
    //将当前显示跨度缩小一倍
    [self zoomInOrZoomOutWithBool:YES];
}

//缩小地图
- (void)zoomOutBtnAction
{
    //放大一倍
    [self zoomInOrZoomOutWithBool:NO];
}

//放大或缩小
- (void)zoomInOrZoomOutWithBool:(BOOL)zoomIn
{
    CGFloat index = 0;
    if (zoomIn) {
        //放大
        index = 0.5;
    }else {
        index = 2;
    }
    
    //region当前地图显示的区域
    CGFloat latitude = self.mapView.region.span.latitudeDelta * index;
    CGFloat longitude = self.mapView.region.span.longitudeDelta * index;
    
    //设置region
    
    //设置范围 带动画
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.region.center, MKCoordinateSpanMake(latitude, longitude)) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
