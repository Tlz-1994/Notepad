//
//  ViewController.m
//  NoteRecord
//
//  Created by stefanie on 16/4/1.
//  Copyright © 2016年 Stefanie. All rights reserved.
//

#import "LZViewController.h"
#import "UIView+Screenshot.h"
#import "UIImage+ImageEffects.h"
#import "FancyTabBar.h"
#import "PersonalViewController.h"
#import "NetRequest.h"
#import "WeatherModel.h"
#import "RecordViewController.h"
#import "RecordModel.h"
#import "FMDBManager.h"
#import "UIImage+Rotation.h"
#import "LLSimpleCamera.h"
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, PhotoType) {
    ONLY_PHOTO = 0,
    TAKE_PHOTO,
    ONLY_WORD,
    NOTHING
};

@interface LZViewController ()<FancyTabBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMapLocationManagerDelegate, AMapSearchDelegate>
{
    UILabel *_weatherLabel;   // 天气温度的label
    UILabel *_cityLabel;      // 城市名字的label
    UILabel *_longitudeLabel; // 经度Label
    UILabel *_latitudeLabel;  // 纬度label
    UILabel *_humidityLabel;  // 空气湿度的label
    AMapSearchAPI *_search;   // 搜索的API
}

@property (nonatomic, strong) LLSimpleCamera *camera;

@property (nonatomic, strong) FancyTabBar *fancyTabBar;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) WeatherModel *weatherModel;
@property (nonatomic, strong) RecordModel *recordModel;

@end

@implementation LZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadSearchAPI];
    [self LoadLBS];
    [self layoutUI];
    [self settingTabbar];
}

- (WeatherModel *)weatherModel {
    if (!_weatherModel) {
        WeatherModel *model = [[WeatherModel alloc] init];
        _weatherModel = model;
    }
    return _weatherModel;
}

- (RecordModel *)recordModel {
    if (!_recordModel) {
        RecordModel *model = [[RecordModel alloc] init];
        _recordModel = model;
    }
    return _recordModel;
}

#pragma mark - 搜索服务的初始化
- (void)loadSearchAPI {
    if (!_search) {
        //初始化检索对象
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *city = response.regeocode.addressComponent.city;
        NSString *province = response.regeocode.addressComponent.province;
        if (city.length > 0) {
            [self loadDatasource:city];
            return;
        }
        if (province.length > 0) {
            [self loadDatasource:province];
            return;
        }
    }
}

//实现天气查询的回调函数
- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    //如果是实时天气
    if(request.type == AMapWeatherTypeLive)
    {
        if(response.lives.count == 0)
        {
            return;
        }
        for (AMapLocalWeatherLive *live in response.lives) {
            self.weatherModel.city = live.city ? live.city: live.province;
            self.weatherModel.date = live.reportTime;
            self.weatherModel.temp = live.temperature;
            self.weatherModel.weather = live.weather;
            self.weatherModel.humidity = live.humidity;
            [self loadWeatherUI];
            LZLog(@"%@", live.temperature);
        }
        // 网络加载转圈消失
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

#pragma mark - 初始化定位服务
- (void)LoadLBS {
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    // 获取到经纬度后发起反地理编码搜索
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude     longitude:location.coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
    
    // 给天气模型经纬度赋值
    self.weatherModel.latitude = [NSString stringWithFormat:@"%.3lf", location.coordinate.latitude];
    self.weatherModel.longitude = [NSString stringWithFormat:@"%.3lf", location.coordinate.longitude];
}

#pragma mark - 初始化数据
- (void)loadDatasource:(NSString *)city {
    //构造AMapWeatherSearchRequest对象，配置查询参数
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = city;
    request.type = AMapWeatherTypeLive; //AMapWeatherTypeLive为实时天气；AMapWeatherTypeForecase为预报天气
    
    //发起行政区划查询
    [_search AMapWeatherSearch:request];
}

#pragma mark - 创建首页UI
- (void)layoutUI {
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建背景视图
    _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_bgImageView];
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.image = [UIImage imageNamed:@"bgbg.jpeg"];
    
    // 添加个人中心入口
    UIButton *personalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personalBtn.frame = CGRectMake(kWidth-60, 35, 50, 50);
    personalBtn.backgroundColor = [UIColor yellowColor];
    personalBtn.layer.cornerRadius = 25;
    personalBtn.clipsToBounds = YES;
    [personalBtn setTitle:@"个人" forState:UIControlStateNormal];
    [personalBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_bgImageView addSubview:personalBtn];
    [personalBtn addTarget:self action:@selector(pushToPersonalVC) forControlEvents:UIControlEventTouchUpInside];
    
    // 设计天气模块UI
    [self loadWeatherUI];
}

- (void)loadWeatherUI {
    if (!_weatherLabel) {
        _weatherLabel = [[LZLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
        _weatherLabel.font = [UIFont systemFontOfSize:70];
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
        _weatherLabel.centerX = kWidth/2.0;
        _weatherLabel.centerY = kHeight/2.0-150;
        [self.view addSubview:_weatherLabel];
    }
    if (!_cityLabel) {
        _cityLabel = [[LZLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _cityLabel.textAlignment = NSTextAlignmentCenter;
        _cityLabel.centerX = kWidth/2.0;
        _cityLabel.y = CGRectGetMaxY(_weatherLabel.frame)+5;
        [self.view addSubview:_cityLabel];
    }
    if (!_longitudeLabel) {
        _longitudeLabel = [[LZLabel alloc] initWithFrame:CGRectMake(10, kHeight/2+20, 200, 35)];
        [self.view addSubview:_longitudeLabel];
    }
    if (!_latitudeLabel) {
        _latitudeLabel = [[LZLabel alloc] initWithFrame:CGRectMake(10, kHeight/2+55, 200, 35)];
        [self.view addSubview:_latitudeLabel];
    }
    if (!_humidityLabel) {
        _humidityLabel = [[LZLabel alloc] initWithFrame:CGRectMake(10, kHeight/2-20, 200, 35)];
        [self.view addSubview:_humidityLabel];
    }
    if (self.weatherModel) {
        _weatherLabel.text = [self.weatherModel.temp stringByAppendingString:@"°"];
        _cityLabel.text = self.weatherModel.city;
        _longitudeLabel.text = [NSString stringWithFormat:@"经度:%@", self.weatherModel.longitude? self.weatherModel.longitude : @"......"];
        _latitudeLabel.text = [NSString stringWithFormat:@"纬度:%@", self.weatherModel.latitude? self.weatherModel.latitude : @"......"];
        _humidityLabel.text = [NSString stringWithFormat:@"空气湿度:%@", self.weatherModel.humidity? self.weatherModel.humidity : @"......"];
    }
    
    UIButton *caremaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    caremaButton.frame = CGRectMake(kWidth-50, kHeight-50, 50, 50);
    [self.view addSubview:caremaButton];
    [caremaButton addTarget:self action:@selector(takePhotos:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    starButton.frame = CGRectMake(0, kHeight-50, 50, 50);
    [self.view addSubview:starButton];
    [starButton addTarget:self action:@selector(starCarema:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 拍照模块（不知不觉就拍了）
- (void)creatCarema {
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetPhoto
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
    [self.camera attachToViewController:self withFrame:CGRectMake(kWidth-70, kHeight-180, 50, 50)];
    self.camera.view.backgroundColor = [UIColor orangeColor];
    self.camera.fixOrientationAfterCapture = NO;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
    }];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 50, 50) cornerRadius:25];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.camera.view.bounds;
    layer.path = path.CGPath;
    self.camera.view.layer.mask = layer;
    self.camera.view.userInteractionEnabled = YES;
    [self.camera start];
    
}

- (void)starCarema:(UIButton *)sender {
    [self creatCarema];
}

- (void)takePhotos:(UIButton *)sender {
    if (self.camera) {
        [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
            if(!error) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
        } exactSeenImage:YES];
    }
}

// 跳转个人中心的方法
- (void)pushToPersonalVC {
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    [self.lcNavigationController pushViewController:personalVC];
}

#pragma mark - 创建tabbar
- (void)settingTabbar {
    _fancyTabBar = [[FancyTabBar alloc]initWithFrame:self.view.bounds];
    [_fancyTabBar setUpChoices:self choices:@[@"dropbox",@"draw",@"camera",@"gallery"] withMainButtonImage:[UIImage imageNamed:@"main_button"]];
    _fancyTabBar.currentDirectionToPopOptions = FancyTabBarItemsPop_Up;
    _fancyTabBar.delegate = self;
    [self.view addSubview:_fancyTabBar];
}

#pragma mark - FancyTabBarDelegate
- (void)optionsButton:(UIButton*)optionButton didSelectItem:(int)index{
    LZLog(@"Hello index %d tapped !", index);
    //GALLERY SEGUE
    switch (index) {
        case 1:
        {
            // 无内容记录 仅有环境信息
            [self pickerImageFromGallery:NOTHING];
        }
            break;
        case 2:
        {
            // 纯文字记录
            [self pickerImageFromGallery:ONLY_WORD];
        }
            break;
        case 3:
        {
            // 拍照加纯文字记录
            [self pickerImageFromGallery:TAKE_PHOTO];
            
        }
            break;
        case 4:
        {
            // 相册选择照片加文字记录
            [self pickerImageFromGallery:ONLY_PHOTO];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 选图片
- (void)pickerImageFromGallery:(PhotoType)type {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate = self;
    
    if (type == TAKE_PHOTO) {
        // 拍摄照片
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    else if(type == ONLY_PHOTO) {
        // 从相册中选取
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    else if (type == ONLY_WORD) {
        RecordViewController *recordVC = [[RecordViewController alloc] init];
        [self dealRecordModelWithImage:nil];
        recordVC.recordMoedl = self.recordModel;
        [self presentViewController:recordVC animated:YES completion:nil];
    }
    else {
        // 只保存环境信息 无任何文字图像记录
        [self dealRecordModelWithImage:nil];
        [FMDBManager addRecordWithRecordModel:self.recordModel];
    }
}

#pragma mark -调出相册的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    RecordViewController *recordVC = [[RecordViewController alloc] init];
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [UIImage fixOrientation:image];
    
    [self dealRecordModelWithImage:image];
    recordVC.recordMoedl = self.recordModel;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //图片存入相册
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:recordVC animated:YES completion:nil];
        }];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:recordVC animated:YES completion:nil];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


// 处理记录模型
- (void)dealRecordModelWithImage:(UIImage *)image {
    self.recordModel.place = self.weatherModel.city;
    self.recordModel.position = [NSString stringWithFormat:@"%@,%@", self.weatherModel.latitude, self.weatherModel.longitude];
    self.recordModel.weather = [NSString stringWithFormat:@"%@ %@°", self.weatherModel.weather, self.weatherModel.temp];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    self.recordModel.time = dateString;
    
    NSString *url = [NSString stringWithFormat:@"%ld", time(NULL)];
    NSString *filePath = [FILE_PATH stringByAppendingPathComponent:url];   // 保存文件的名称
    if (image) {
        BOOL result = [UIImagePNGRepresentation(image) writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
        NSLog(@"%d  %@", result, filePath);
        self.recordModel.photoUrl = url;
    } else {
        self.recordModel.photoUrl = nil;
    }
    self.recordModel.uid = [LZNSUserDefaults valueForKey:USERID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
