//
//  SCLocationManager.m
//  SYPProject
//
//  Created by sunyuping on 13-7-1.
//
//

#import "SCLocationManager.h"

@interface SCLocationManager()
- (void)startLocTimer;
- (void)cancelLocTimer;
@end

@implementation SCLocationManager
@synthesize locationManager = _locationManager;
@synthesize currentLoc = _currentLoc;
@synthesize currentHead = _currentHead;
@synthesize delegate = _delegate;
@synthesize keepOpening = _keepOpening;

- (void)dealloc
{
    RELEASE(_locationManager);
    RELEASE(_currentLoc);
    RELEASE(_currentHead);
    RELEASE(_timer);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        //if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
        //}
        [self.locationManager stopUpdatingHeading];
        self.locationManager.distanceFilter = 0.0f;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
        self.currentLoc = nil;
        self.keepOpening = NO;
        //_isLocating = NO;
        _timeout = 3.0f;
        
    }
    return self;
}

- (void)startUpdateLocation
{
    // 如果正在定位，
    //    if(_isLocating){
    //        return;
    //    }
    //    _isLocating = YES;
    
    if(self.keepOpening){
        self.currentLoc = [self.locationManager location];
        //_isLocating = NO;
        if(self.currentLoc){
            if([self.delegate respondsToSelector:@selector(RCLocMgrNewLocation:error:)])
                [self.delegate SCLocMgrNewLocation:self.currentLoc error:nil];
        }
        else{
            NSError* errorCode = [NSError errorWithDomain:@"" code:40011 message:nil];
            if([self.delegate respondsToSelector:@selector(RCLocMgrNewLocation:error:)])
                [self.delegate SCLocMgrNewLocation:nil error:errorCode];
        }
    }
    else{
        [self.locationManager startUpdatingLocation];
        
        [self startLocTimer];
    }
}

- (void)stopUpdateLocation
{
    //_isLocating = NO;
    [self.locationManager stopUpdatingLocation];
}

- (BOOL)isLocationServicesEnabled {
    BOOL enabled = [CLLocationManager locationServicesEnabled];
    
    NSString *versionStr = [[UIDevice currentDevice] systemVersion];
    
    // 4.3 连续调用[CLLocationManager locationServicesEnabled]和[CLLocationManager authorizationStatus]会出现没有定位
    // 服务警告的问题，不调用[CLLocationManager authorizationStatus]却又取不到正确的enabled状态，故将版本在4.2和5.0之间做特殊
    //处理，第一次判断enabled不调用[CLLocationManager authorizationStatus]以使得定位服务警告能正确提示，以后每次定位以
    //[CLLocationManager authorizationStatus]为准
    BOOL enabledOffset = [[NSUserDefaults standardUserDefaults] boolForKey:@"LocationEnabledOffset"];
    
    if (enabled && [versionStr compare:@"4.2" options:NSNumericSearch] != NSOrderedAscending) {
        if ([versionStr compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending) {
            // 4.2 < version < 5.0
            if (enabledOffset) {
                // 弹出过定位服务警告
                CLAuthorizationStatus locationAuthStatus = [CLLocationManager authorizationStatus];
                enabled = (kCLAuthorizationStatusAuthorized == locationAuthStatus);
            }
            else{
                // 这次给机会弹出定位服务警告
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LocationEnabledOffset"];
            }
        }
        else{
            CLAuthorizationStatus locationAuthStatus = [CLLocationManager authorizationStatus];
            enabled = (kCLAuthorizationStatusAuthorized == locationAuthStatus);
        }
    }
	return enabled;
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager  didUpdateToLocation:(CLLocation *)newLocation  fromLocation:(CLLocation *)oldLocation
{
    // 如果定位结果生成的时间已经超过了5分钟，则放弃。
    NSLog(@"newLocation:%@",newLocation);
    [[AudioManager sharedInstance] playSystemSoundWithTag:SoundEffectType_PushMessage];
    NSTimeInterval age = [newLocation.timestamp timeIntervalSinceNow];
    if (age + 360.0f < 0){
        return;
    }
    //    if(newLocation.horizontalAccuracy < 0)
    //        return;
    //    if(!_isLocating)
    //        return;
    //
    //    _isLocating = NO;
    if(!self.currentLoc){
        self.currentLoc = newLocation;
    }
    else{
        NSTimeInterval age1 = [self.currentLoc.timestamp timeIntervalSinceNow];
        if(age > age1){
            self.currentLoc = newLocation;
        }
    }
    //    if([self.delegate respondsToSelector:@selector(RCLocMgrNewLocation:error:)])
    //        [self.delegate RCLocMgrNewLocation:self.currentLoc error:nil];
    
    //    if(!self.keepOpening)
    //        [self.locationManager stopUpdatingLocation];
    
    return;
}

// Called when there is an error getting the location
// TODO: Update this function to return the proper info in the proper UI fields
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    // stop locate
    //    _isLocating = NO;
    
    NSError* errorCode = [NSError errorWithDomain:@"" code:40011 message:nil];
    
    if ([error domain] == kCLErrorDomain) {
        
        // We handle CoreLocation-related errors here
        
        switch ([error code]) {
            case kCLErrorDenied:
                errorCode = [NSError errorWithDomain:@"" code:40011 message:nil];
                break;
                
            case kCLErrorLocationUnknown:
                break;
                
            default:
                break;
        }
    } else {
        
    }
    if([self.delegate respondsToSelector:@selector(RCLocMgrNewLocation:error:)])
        [self.delegate SCLocMgrNewLocation:nil error:errorCode];
    
    if(!self.keepOpening)
        [self.locationManager stopUpdatingLocation];
}

- (void)setTimeout:(float)seconds
{
    _timeout = seconds;
}

- (void)startLocTimer
{
    if(_timer == nil)
    {
        NSLog(@"start scheduled timer.");
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeout
                                                  target:self
                                                selector:@selector(sendLocation)
                                                userInfo:nil
                                                 repeats:YES];
        
    }
}

- (void)cancelLocTimer
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)sendLocation
{
    NSLog(@"sendLocation");
    return;
    [self cancelLocTimer];
    NSError* errorCode = [NSError errorWithDomain:@"" code:40011 message:nil];
    if(self.delegate && [self.delegate respondsToSelector:@selector(RCLocMgrNewLocation:error:)])
        [self.delegate SCLocMgrNewLocation:self.currentLoc error:errorCode];
    
    if(!self.keepOpening)
        [self.locationManager stopUpdatingLocation];  
}

@end
