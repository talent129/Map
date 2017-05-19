//
//  ViewController.m
//  导航画线
//
//  Created by mac on 17/5/12.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *destinationField;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建及请求用户授权
    self.manager = [CLLocationManager new];
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
    }
    
    //设置代理
    self.mapView.delegate = self;  //画线
    
}

- (IBAction)navigationBtnAction:(id)sender {
    
    //创建CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    
    //地理编码 可能出现重名 实际需要给用户列表选择
    [geocoder geocodeAddressString:self.destinationField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            NSLog(@"错误");
            return ;
        }
        
        //获取地标对象  暂时取最后一个
        CLPlacemark *mark = placemarks.lastObject;
        
        //创建MKPlacemark
        MKPlacemark *mp = [[MKPlacemark alloc] initWithPlacemark:mark];
        
        //创建一个MKMapItem 终点
        MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:mp];
        
        //起点位置
//        MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
        
        //实现画线
//        //导航/画线 跟苹果服务器发送请求
//        //创建方向请求对象
//        MKDirectionsRequest *request = [MKDirectionsRequest new];
//        //设置起点
//        request.source = sourceItem;
//        //设置终点
//        request.destination = destinationItem;
//        
//        //创建方向对象
//        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
//        
//        //计算两点之间路线
//        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
//            
//            //防错处理
//            if (response.routes.count == 0 || error) {
//                
//                NSLog(@"错误");
//                return ;
//            }
//            
//            //获取路线信息
//            for (MKRoute *route in response.routes) {
//                
//                //获取polyline 
//                MKPolyline *polyline = route.polyline;//地图上显示的线段
//                
//                //添加到地图上
//                //Overlay: 遮盖物
//                [self.mapView addOverlay:polyline];
//            }
//        }];
        
        //导航和画线前面步骤一致  下面为导航
        //调用open类 打开导航
        //WithItems 要定位的点
        //launchOptions 导航参数
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey : @(MKMapTypeHybrid), MKLaunchOptionsShowsTrafficKey : @(YES)};
        
        [MKMapItem openMapsWithItems:@[destinationItem] launchOptions:options];
        
    }];
    
}

- (IBAction)drawLineAction:(id)sender {
    
    //收起键盘
    [self.view endEditing:YES];
    
    //创建CLGeocoder对象
    CLGeocoder *geocoder = [CLGeocoder new];
    
    //地理编码 可能出现重名 实际需要给用户列表选择
    [geocoder geocodeAddressString:self.destinationField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            NSLog(@"错误");
            return ;
        }
        
        //获取地标对象  暂时取最后一个
        CLPlacemark *mark = placemarks.lastObject;
        
        //创建MKPlacemark
        MKPlacemark *mp = [[MKPlacemark alloc] initWithPlacemark:mark];
        
        //创建一个MKMapItem 终点
        MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:mp];
        
        //起点位置
        MKMapItem *sourceItem = [MKMapItem mapItemForCurrentLocation];
        
        //实现画线
        //导航/画线 跟苹果服务器发送请求
        //创建方向请求对象
        MKDirectionsRequest *request = [MKDirectionsRequest new];
        //设置起点
        request.source = sourceItem;
        //设置终点
        request.destination = destinationItem;
        
        //创建方向对象
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        
        //计算两点之间路线
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
            
            //防错处理
            if (response.routes.count == 0 || error) {
                
                NSLog(@"错误");
                return ;
            }
            
            //获取路线信息
            for (MKRoute *route in response.routes) {
                
                //获取polyline
                MKPolyline *polyline = route.polyline;//地图上显示的线段
                
                //添加到地图上
                //Overlay: 遮盖物
                [self.mapView addOverlay:polyline];
            }
        }];
        
    }];
}

#pragma mark -
//当给地图添加遮盖物的时候会调用此方法
//设置一个渲染物对象 添加到地图上
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    //创建折线渲染物对象 必须
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    
    //设置颜色 必须
    renderer.strokeColor = [UIColor blueColor];
    
    //设置线宽
    renderer.lineWidth = 1;
    
    //返回
    return renderer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
