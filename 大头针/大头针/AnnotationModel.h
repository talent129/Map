//
//  AnnotationModel.h
//  大头针
//
//  Created by mac on 17/5/12.
//  Copyright © 2017年 cai. All rights reserved.
//

/*
 导入框架   MapKit
 遵守协议   MKAnnotation
 设置属性   直接去协议中拷贝 删除readonly
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationModel : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
