//
//  RRLocation.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRLocation.h"

@implementation RRLocation


-(void)getLocaltion{
    RRLOGI("开始定位。。。。。。。");
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    // [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager  didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    RRLOGI("位置信息==%f,=%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);//coordinate
    [self getLocationInfo:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}
- (void)locationManager:(CLLocationManager *)manager   didFailWithError:(NSError *)error {
    RRLOGI("定位失败！！！！！");
}

-(void)getLocationInfo:(double)latitude longitude:(double)longitude{
    
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude = longitude ;
    coordinate2D.latitude = latitude;
    MKReverseGeocoder *reverseGeocoder =[[[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D] autorelease];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
}

//#pragma mark -
//#pragma mark MKReverseGeocoderDelegate methods
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    RRLOGI("reverse finished...");
    RRLOGI("country:%@",placemark.country);
    RRLOGI("countryCode:%@",placemark.countryCode);
    RRLOGI("locality:%@",placemark.locality);
    RRLOGI("subLocality:%@",placemark.subLocality);
    RRLOGI("postalCode:%@",placemark.postalCode);
    RRLOGI("subThoroughfare:%@",placemark.subThoroughfare);
    RRLOGI("thoroughfare:%@",placemark.thoroughfare);
    RRLOGI("administrativeArea:%@",placemark.administrativeArea);
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    RRLOGI("error %@" , error);
}




@end
