//
//  ViewController.m
//  CMap
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 CYC. All rights reserved.
//

// 设置和启用百度地图



#import "ViewController.h"
#import "BDheader.h"

@interface ViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate> {

    BMKMapView *_mapView;       // 地图
    BMKLocationService *_locService;    //定位服务
    BMKPointAnnotation *_annotation;    //大头针
    CLLocationCoordinate2D _coor;        // 显示范围
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化BMKLocationService定位功能
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    // 启动LocationService
    [_locService startUserLocationService];
    
    // 创建地图
    _mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    // 创建大头针
    _annotation = [[BMKPointAnnotation alloc]init];
    
    // 显示范围
    _mapView.showsUserLocation = YES;//显示定位图层
    
    // 切换为卫星图
    // [_mapView setMapType:BMKMapTypeSatellite];
    
    // 切换为普通视图
    [_mapView setMapType:BMKMapTypeStandard];
    
    // 打开实时路况图层
    // [_mapView setTrafficEnabled:YES];
    
    // 打开百度城市热力图图层（百度自有数据）
    // [_mapView setBaiduHeatMapEnabled:YES];
    
    
    
    // 禁用旋转手势
    // _mapView.rotateEnabled = NO;
    
    // 地图logo位置
    /*
     
     BMKLogoPositionLeftBottom = 0,          /// 地图左下方
     BMKLogoPositionLeftTop,                 /// 地图左上方
     BMKLogoPositionCenterBottom,            /// 地图中下方
     BMKLogoPositionCenterTop,               /// 地图中上方
     BMKLogoPositionRightBottom,             /// 地图右下方
     BMKLogoPositionRightTop,                /// 地图右上方
     
    */
    _mapView.logoPosition = BMKLogoPositionRightBottom;
    
    // 地图边界 UIEdgeInsets(上左下右)  无效
    // _mapView.mapPadding = UIEdgeInsetsMake(20, 10, 30, 40);
    
    // 比例等级，同时支持设置MaxZoomLevel和minZoomLevel。
    
    
    // 打开室内地图（默认关闭）
    // _mapView.baseIndoorMapEnabled = YES;
    
    
    self.view = _mapView;
    
    
    
    
    
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    [manager startUpdatingLocation];
    
}


/*
 
    自2.0.0起，BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，
    并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在
    viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegate，代码如下：
 
*/
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    // 大头针
    // [self _addPointAnnotation];
    
    // 折线覆盖
    // [self _addLine];         // 线段
    // [self _addColorLine];    // 多色线
    // [self _cycleLine];          // 弧线
    // [self linesAndFill];        // 所变形覆盖物
    
    // 长按添加行不通
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_addLine)];
//    longPress.minimumPressDuration = 2;
//    [_mapView addGestureRecognizer:longPress];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}


#pragma mark - 添加UI
// 添加大头针
- (void)_addPointAnnotation {

    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [_mapView addAnnotation:annotation];
    
    // 移除大头针
    //    if (annotation != nil) {
    //        [_mapView removeAnnotation:annotation];
    //    }

}
// 添加折线覆盖物
- (void)_addLine {

    CLLocationCoordinate2D coors[3] = {0};
    coors[0].latitude = 39.315;
    coors[0].longitude = 116.304;
    coors[1].latitude = 39.915;
    coors[1].longitude = 116.404;
    coors[2].latitude = 40.015;
    coors[2].longitude = 117.004;
    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:3];
    [_mapView addOverlay:polyline];


}

// 添加分段颜色绘制折线覆盖物
- (void)_addColorLine {

    //构建顶点数组
    CLLocationCoordinate2D coords[5] = {0};
    coords[0].latitude = 39.965;
    coords[0].longitude = 116.404;
    coords[1].latitude = 39.925;
    coords[1].longitude = 116.454;
    coords[2].latitude = 39.955;
    coords[2].longitude = 116.494;
    coords[3].latitude = 39.905;
    coords[3].longitude = 116.654;
    coords[4].latitude = 39.965;
    coords[4].longitude = 116.704;
    //构建分段纹理索引数组
    NSArray *textureIndex = [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:0],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:2],
                             [NSNumber numberWithInt:1], nil];
    
    //构建BMKPolyline,使用分段纹理
    BMKPolyline *polyLine = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:textureIndex];
    //添加分段纹理绘制折线覆盖物
    [_mapView addOverlay:polyLine];

}

// 弧线
- (void)_cycleLine {

    //添加弧线覆盖物
    //传入的坐标顺序为起点、途经点、终点
    CLLocationCoordinate2D coords[3] = {0};
    coords[0].latitude = 39.9374;
    coords[0].longitude = 116.350;
    coords[1].latitude = 39.9170;
    coords[1].longitude = 116.360;
    coords[2].latitude = 39.9479;
    coords[2].longitude = 116.373;
    
    BMKArcline *arcline = [BMKArcline arclineWithCoordinates:coords];
    [_mapView addOverlay:arcline];

}

// 多边形覆盖物
- (void)linesAndFill {

    // 添加多边形覆盖物
    CLLocationCoordinate2D coords[3] = {0};
    coords[0].latitude = 39;
    coords[0].longitude = 116;
    coords[1].latitude = 38;
    coords[1].longitude = 115;
    coords[2].latitude = 38;
    coords[2].longitude = 117;
    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coords count:3];
    
    [_mapView addOverlay:polygon];

}

#pragma mark - 协议方法
// 大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        // 大头针颜色
        /*
         
         BMKPinAnnotationColorRed = 0,
         BMKPinAnnotationColorGreen,
         BMKPinAnnotationColorPurple
         
        */
        
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}


// 折线覆盖物
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    
    // 单色线段
//    if ([overlay isKindOfClass:[BMKPolyline class]]){
//        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
//        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
//        polylineView.lineWidth = 5.0;
//        
//        return polylineView;
//    }
//    return nil;
    
    // 纹理线段
//    if ([overlay isKindOfClass:[BMKPolyline class]]) {
//        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
//        polylineView.lineWidth = 5;
//        /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
//        polylineView.colors = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor redColor], [UIColor yellowColor], nil];
//        return polylineView;
//    }
//    
//    return nil;
    
    // 多色线段
//    if ([overlay isKindOfClass:[BMKPolyline class]]){
//        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
//        polylineView.lineWidth = 5;
//        polylineView.isFocus = YES;// 是否分段纹理绘制（突出显示），默认YES
//        polylineView.colors = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor redColor], [UIColor yellowColor], nil];
//        
//        return polylineView;
//    }
//    return nil;
    
    // 弧线
//    if ([overlay isKindOfClass:[BMKArcline class]])
//    {
//        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithOverlay:overlay];
//        arclineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//        arclineView.lineWidth = 5.0;
//        
//        return arclineView;
//    }
//    return nil;

    // 多边形覆盖物
    if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth = 5.0;
        
        return polygonView;
    }
    return nil;
    
    
}

// 通过实现delegate方法，来监听进入和移出室内图事件：
-(void)mapview:(BMKMapView *)mapView baseIndoorMapWithIn:(BOOL)flag   baseIndoorMapInfo:(BMKBaseIndoorMapInfo *)info{
    if (flag) {//进入室内图
        NSLog(@"进入室内地图");
    } else {//移出室内图
        NSLog(@"移出室内地图");
    }
}

// 处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
    // NSLog(@"方向 is %@",userLocation.heading);
    

}

// 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"地理位置更新了 lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coor.latitude = userLocation.location.coordinate.latitude;
        _coor.longitude = userLocation.location.coordinate.longitude;
//        _annotation.coordinate = _coor;
//        _annotation.title = @"我在这";
//        [_mapView addAnnotation:_annotation];
        
        
        // 将地图视觉移动到当前位置，并设定视图缩放大小
        BMKCoordinateSpan span = BMKCoordinateSpanMake(0.002, 0.002);
        _mapView.region = BMKCoordinateRegionMake(_coor, span);////限制地图显示范围
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    });
    
    
    [_mapView updateLocationData:userLocation];
    
    
    
//    NSString *lat = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
//    NSString *lon = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    
    
    
    
    
}

// 将经纬度反编译成城市
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0) __TVOS_PROHIBITED __WATCHOS_PROHIBITED {

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder  reverseGeocodeLocation:newLocation
                    completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                        if (placemarks.count > 0) {
                            for (CLPlacemark *place in placemarks) {
                                
                                // 当前城市名
                                NSString *cityName = place.locality;
                                NSLog(@"%@",cityName);
                            }
                        }
                    }];

}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
