//
//  SCLocationManager.h
//  SYPProject
//
//  Created by sunyuping on 13-7-1.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol SCLocationManagerDelegate<NSObject>
@optional
- (void)SCLocMgrNewLocation:(CLLocation*)location error:(NSError*)error;
@end

@interface SCLocationManager : NSObject<CLLocationManagerDelegate>{
    CLLocationManager* _locationManager;
    CLLocation* _currentLoc;
    CLHeading* _currentHead;
    id<SCLocationManagerDelegate> _delegate;
    BOOL _keepOpening;
@private
    BOOL _isLocating;
    NSTimer* _timer;
    float _timeout;//等待定位时间。
}
@property (nonatomic, retain)CLLocationManager* locationManager;
@property (nonatomic, retain)CLLocation* currentLoc;
@property (nonatomic, retain)CLHeading* currentHead;
@property (nonatomic, assign)id<SCLocationManagerDelegate> delegate;
@property (nonatomic, assign)BOOL keepOpening;

- (void)startUpdateLocation;
- (void)stopUpdateLocation;
/**
 *判断定位是否开启
 */
- (BOOL)isLocationServicesEnabled;
- (void)setTimeout:(float)seconds;


@end
