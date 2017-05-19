//
//  ViewController.m
//  地理编码
//
//  Created by mac on 17/5/11.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *longLabel;
@property (nonatomic, strong) UILabel *laLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *clickBtn;

/***************************************************/

@property (nonatomic, strong) UITextField *longField;
@property (nonatomic, strong) UITextField *laField;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIButton *reverseButton;

@end

@implementation ViewController

#pragma mark -懒加载
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 50, 100, 30)];
        _textField.backgroundColor = [UIColor cyanColor];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"输入地址";
    }
    return _textField;
}

- (UILabel *)longLabel
{
    if (!_longLabel) {
        _longLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 200, 30)];
        _longLabel.textColor = [UIColor purpleColor];
        _longLabel.text = @"经度:";
    }
    return _longLabel;
}

- (UILabel *)laLabel
{
    if (!_laLabel) {
        _laLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, 200, 30)];
        _laLabel.textColor = [UIColor purpleColor];
        _laLabel.text = @"纬度:";
    }
    return _laLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, Screen_Width - 30, 30)];
        _nameLabel.textColor = [UIColor purpleColor];
        _nameLabel.text = @"详细地址:";
    }
    return _nameLabel;
}

- (UIButton *)clickBtn
{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.frame = CGRectMake(Screen_Width - 150, 140, 100, 50);
        _clickBtn.backgroundColor = [UIColor orangeColor];
        [_clickBtn setTitle:@"地理编码" forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

/***************************************************/

- (UITextField *)longField
{
    if (!_longField) {
        _longField = [[UITextField alloc] initWithFrame:CGRectMake(15, 250, (Screen_Width - 30 - 15)/2.0, 30)];
        _longField.backgroundColor = [UIColor cyanColor];
        _longField.borderStyle = UITextBorderStyleRoundedRect;
        _longField.placeholder = @"输入经度";
    }
    return _longField;
}


- (UITextField *)laField
{
    if (!_laField) {
        _laField = [[UITextField alloc] initWithFrame:CGRectMake((Screen_Width - 30 - 15)/2.0 + 30, 250, (Screen_Width - 30 - 15)/2.0, 30)];
        _laField.backgroundColor = [UIColor cyanColor];
        _laField.borderStyle = UITextBorderStyleRoundedRect;
        _laField.placeholder = @"输入纬度";
    }
    return _laField;
}

- (UILabel *)cityLabel
{
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 350, Screen_Width - 30, 30)];
        _cityLabel.textColor = [UIColor purpleColor];
        _cityLabel.text = @"城市:";
    }
    return _cityLabel;
}

- (UIButton *)reverseButton
{
    if (!_reverseButton) {
        _reverseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reverseButton.frame = CGRectMake(15, 300, 100, 30);
        _reverseButton.backgroundColor = [UIColor orangeColor];
        [_reverseButton setTitle:@"反地理编码" forState:UIControlStateNormal];
        [_reverseButton addTarget:self action:@selector(reverseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reverseButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    [self createUIReverse];
}

#pragma mark -createUI  地理编码
- (void)createUI
{
    [self.view addSubview:self.textField];
    [self.view addSubview:self.laLabel];
    [self.view addSubview:self.longLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.clickBtn];
}

//反地理编码
- (void)createUIReverse
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, Screen_Width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    [self.view addSubview:self.longField];
    [self.view addSubview:self.laField];
    [self.view addSubview:self.cityLabel];
    [self.view addSubview:self.reverseButton];
}

//地理编码
- (void)clickBtnAction
{
    if (self.textField.text.length == 0) {
        NSLog(@"未输入地址");
        return;
    }
    //创建一个CLGeocoder对象
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //实现地理编码
    //地理编码 可能出现重名情况，所以需要对地标大于1的进行处理 给用户一个列表选择
    [geocoder geocodeAddressString:self.textField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable CLGeocoder, NSError * _Nullable error) {
        //CLGeocoder: 地标数组 ->主要CLLocation 城市属性
        
        //遍历数组
        if (CLGeocoder.count == 0 || error) {
            NSLog(@"解析有问题");
            return ;
        }
        for (CLPlacemark *placemark in CLGeocoder) {
            NSLog(@"long: %f", placemark.location.coordinate.longitude);
            NSLog(@"la: %f", placemark.location.coordinate.latitude);
            NSLog(@"name: %@", placemark.name);
            
            self.longLabel.text = [NSString stringWithFormat:@"经度: %f", placemark.location.coordinate.longitude];
            self.laLabel.text = [NSString stringWithFormat:@"纬度: %f", placemark.location.coordinate.latitude];
            self.nameLabel.text = [NSString stringWithFormat:@"具体地址: %@", placemark.name];
        }
    }];
    
}

//反地理编码
- (void)reverseButtonAction
{
    if (self.laField.text.length == 0 || self.longField.text.length == 0) {
        NSLog(@"未输入经度或纬度");
        return;
    }
    
    //创建一个CLGeocoder对象
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //创建一个CLLocation对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[self.laField.text doubleValue] longitude:self.longField.text.doubleValue];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        
        if (placemarks.count == 0 || error) {
            NSLog(@"解析出错--%@", error);
            return ;
        }
        
        //遍历数组 一般不会出现重复 可以不遍历 取值lastObject
        for (CLPlacemark *placemark in placemarks) {
            self.cityLabel.text = [NSString stringWithFormat:@"城市: %@", placemark.locality];
        }
        
    }];
    
}

//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
