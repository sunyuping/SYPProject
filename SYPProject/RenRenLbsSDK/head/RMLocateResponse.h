//
//  RMLocateResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"

@interface RMLocateResponse : RMObject{
    double longitude;               /// 经度
    double latitude;                /// 纬度
    double accuracy;                /// 精确度
    NSString *address;              /// 地址
    NSString *nation;                
    NSString *province;              
    NSString *city;                 
    NSString *district;             
    NSString *poiName;              
    NSString *direction;            
    NSString *distance;              
}
@property(nonatomic, readonly) double longitude;               
@property(nonatomic, readonly) double latitude;                
@property(nonatomic, readonly) double accuracy;  
@property(nonatomic, readonly) NSString *address; 

@property(nonatomic, readonly) NSString *nation; 
@property(nonatomic, readonly) NSString *province; 
@property(nonatomic, readonly) NSString *city; 
@property(nonatomic, readonly) NSString *district; 
@property(nonatomic, readonly) NSString *poiName; 
@property(nonatomic, readonly) NSString *direction; 
@property(nonatomic, readonly) NSString *distance; 
@end
