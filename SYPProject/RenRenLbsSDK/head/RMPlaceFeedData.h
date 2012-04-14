//
//  RMPlaceFeedDatra.h
//  RMSDK
//
//  Created by Renren on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"



@interface RMStatusForward : RMObject{
    long statusOwerId;       ///新鲜事拥有者id    
    NSString *status;        ///新鲜事
    long owerId;  ///转发者id
    NSString *owerName; ///转发者名称
}
@property(nonatomic, readonly) long statusOwerId;           
@property(nonatomic, readonly) NSString *status;        
@property(nonatomic, readonly) long owerId;  
@property(nonatomic, readonly) NSString *owerName; 
@end



@interface RMAttachementList : RMObject{
    NSString *media_id;           ///id
    NSString *url;        ///链接
    NSString *owner_id;  ///拥有者id
    NSString *type; ///类型
    NSString *src; ///
    NSString *digest; ///摘要
    NSString *main_url; ///主页地址
}
@property(nonatomic, readonly) NSString *media_id;           
@property(nonatomic, readonly) NSString *url;        
@property(nonatomic, readonly) NSString *owner_id;  
@property(nonatomic, readonly) NSString *type; 
@property(nonatomic, readonly) NSString *src; 
@property(nonatomic, readonly) NSString *digest; 
@property(nonatomic, readonly) NSString *main_url; 
@end