//
//  ViewController.m
//  大头针
//
//  Created by mac on 17/5/12.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "AnnotationModel.h"

@interface ViewController ()

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation ViewController

#pragma mark -
- (MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    }
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.mapView];
    
    //MKUserLocation 大头针模型
    
//    //添加大头针  自定义大头针
//    
//    //创建大头针
//    AnnotationModel *model = [[AnnotationModel alloc] init];
//    model.coordinate = CLLocationCoordinate2DMake(40, 116);
//    model.title = @"北京市";
//    model.subtitle = @"北京子标题";
//    
//    //添加到地图上
//    [self.mapView addAnnotation:model];
//    
//    //添加第二个大头针
//    AnnotationModel *model2 = [[AnnotationModel alloc] init];
//    model2.coordinate = CLLocationCoordinate2DMake(35.29, 115.1);
//    model2.title = @"东明";
//    model2.subtitle = @"子标题";
//    [self.mapView addAnnotation:model2];
}

#pragma mark -点击添加大头针
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取点击地图的点
    CGPoint point = [[touches anyObject] locationInView:self.mapView];
    
    //将点击的点转换成经纬度
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    //添加大头针  自定义大头针

    //创建大头针
    AnnotationModel *model = [[AnnotationModel alloc] init];
    model.coordinate = coordinate;
    
    //反地理编码 获取标题 子标题
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count == 0 || error) {
            NSLog(@"解析出错--%@", error);
            return ;
        }
        
        //遍历数组 一般不会出现重复 可以不遍历 取值lastObject
        CLPlacemark *placeMark = [placemarks lastObject];
        
        model.title = placeMark.locality;
        model.subtitle = placeMark.name;
        
        NSLog(@"%@--%@", placeMark.locality, placeMark.name);
        
    }];

    //添加到地图上
    [self.mapView addAnnotation:model];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
