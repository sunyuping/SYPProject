//
//  RMPlaceData.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
#import "RMPlaceFeedData.h"
@interface RMPlaceData : RMObject

@end


///RMCategory 获取poi类型
@interface RMCategory : RMObject{
    NSString *categoryId;           ///poi类型id
    NSString *categoryName;        ///poi类型名称

}
@property(nonatomic, readonly) NSString *categoryId;
@property(nonatomic, readonly) NSString *categoryName;
@end



///RMActivity 某个pid的活动列表内容
@interface RMActivity : RMObject{
    NSString *period_msg;    ///活动的有效期       
    NSString *message;    ///活动名称
    NSString *activity_icon;  ///活动图标         
    NSString *url; ///活动的地址
    NSInteger type;///活动的类型
}
@property(nonatomic, readonly) NSString *period_msg;
@property(nonatomic, readonly) NSString *message;
@property(nonatomic, readonly) NSString *activity_icon;           
@property(nonatomic, readonly) NSString *url; 
@property(nonatomic, readonly) NSInteger type;
@end



///RMFriendsList获取好友列表，目前不分远近
@interface RMFriendsList : RMObject{
	NSString * add_time;///加入时间
	NSInteger data_type;///dataType定义1：带位置状态 2：照片 3：签到
	NSInteger distance;///距离
	NSString *head_url;///头像地址
	NSString * latitude_gps;///GPS维度
	NSString * latitude_poi;///POI维度
	NSString * locate_type;///位置类型
	NSString * longitude_gps;///GPS经度
	NSString * longitude_poi;///POI经度
	NSString *main_url;///主页地址
	NSString *user_name;///用户名
	NSString *pid;///PID
	NSString *poi_address;///POI地址
	NSString *poi_name;///POI名称
	NSString *poi_phone;///POI电话
	NSInteger privacy;///隐私
	NSString *status_text;///状态内容
	NSString *tiny_url;///小头像地址
	NSString * user_id;///用户ID
	NSString * lbs_id;///LBS id
	NSString * source_id;///新鲜事ID
}
@property(nonatomic, readonly) NSString * add_time;
@property(nonatomic, readonly) NSInteger data_type;
@property(nonatomic, readonly) NSInteger distance;
@property(nonatomic, readonly) NSString *head_url;
@property(nonatomic, readonly) NSString * latitude_gps;
@property(nonatomic, readonly) NSString * latitude_poi;
@property(nonatomic, readonly) NSString * locate_type;
@property(nonatomic, readonly) NSString * longitude_gps;
@property(nonatomic, readonly) NSString * longitude_poi;
@property(nonatomic, readonly) NSString *main_url;
@property(nonatomic, readonly) NSString *user_name;
@property(nonatomic, readonly) NSString *pid;
@property(nonatomic, readonly) NSString *poi_address;
@property(nonatomic, readonly) NSString *poi_name;
@property(nonatomic, readonly) NSString *poi_phone;
@property(nonatomic, readonly) NSInteger privacy;
@property(nonatomic, readonly) NSString *status_text;
@property(nonatomic, readonly) NSString *tiny_url;
@property(nonatomic, readonly) NSString * user_id;
@property(nonatomic, readonly) NSString * lbs_id;
@property(nonatomic, readonly) NSString * source_id;
@end



///RMPoiListItem 获取poi列表
@interface RMPoiListItem : RMObject {
    NSInteger distance;///距离
    NSString *lon;///经度
    NSString *phone;///电话
    float weight;///weight
    NSString *address;///地址
    NSString *poiName;///POI名称
    NSString *pid;///pid
    NSString *lat;///维度
    NSString *activityCaption;///活动标题
    NSInteger activityCount;///活动数量
    NSInteger nearByActivityCount;///附近活动数量
    NSString *county;///郡 县
    NSString *streetName;///街道名称
    NSString *nation;///国家
    NSString *city;///城市
    NSString *province;///省
}

@property(nonatomic, readonly)NSInteger distance;
@property(nonatomic, readonly)NSString *lon;
@property(nonatomic, readonly)NSString *phone;
@property(nonatomic, readonly)float weight;
@property(nonatomic, readonly)NSString *address;
@property(nonatomic, readonly)NSString *poiName;
@property(nonatomic, readonly)NSString *pid;
@property(nonatomic, readonly)NSString *lat;
@property(nonatomic, readonly)NSString *activityCaption;
@property(nonatomic, readonly)NSInteger activityCount;
@property(nonatomic, readonly)NSInteger nearByActivityCount;
@property(nonatomic, readonly)NSString *county;
@property(nonatomic, readonly)NSString *streetName;
@property(nonatomic, readonly)NSString *nation;
@property(nonatomic, readonly)NSString *city;
@property(nonatomic, readonly)NSString *province;
@end



///RMPoiList 获取附近活动poi
@interface RMPoiList : RMObject{
	NSString *pid;/// pid
	NSString *name;///名称
	NSString *activity_caption;///活动标题
	NSString *address;///地址
	NSString *url;///链接
	NSString *activity_contents;///活动内容
    
    
    
      NSString *distance;   ///距离
      NSString *event_count; ///事件数量
      NSString *from; ///来源
      NSString *event_type; ///关联关系中活动的类型 
      NSString *broad_sdate; ///关联关系中活动的推广开始时间
      NSString *broad_edate; ///关联关系中活动的推广结束时间 
      NSString *event_sdate; ///关联关系中活动的开始时间 
      NSString *event_edate; ///关联关系中活动的结束时间 
      NSString *event_source; ///关联关系中活动的来源标识 
      NSString *event_source_wapurl;  ///关联关系中活动的来源wap地址 
      NSString *event_mobile_logourl; ///关联关系中活动的小图地址 
      NSString *event_web_logourl;  ///关联关系中的活动的大图地址 
      NSString *longitude; ///关联关系中活动举行第的经度 
      NSString *latitude; ///关联关系中活动举行地的维度 
      NSString *description;   ///关联关系中活动的描述 
      NSString *poi_type;///关联关系中活动的地点类型 
      NSString *group_buy_id; ///团购类型活动 ,对象唯一标识ID 
      NSString *group_buy_original_price;  ///原价 ，适用于团购类型活动 
      NSString *group_buy_current_price; ///现价 ，适用于团购类型活动 
     NSString * group_buy_rate;  ///折扣 ，适用于团购类型活动 
     NSString * group_buy_spare; ///节省 ，适用于团购类型活动 
      NSString *event_id; ///eventId 
}
@property(nonatomic, readonly) NSString *pid;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSString *activity_caption;
@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSString *url;
@property(nonatomic, readonly) NSString *activity_contents;



@property(nonatomic, readonly) NSString *distance;   
@property(nonatomic, readonly) NSString *event_count; 
@property(nonatomic, readonly) NSString *from; 
@property(nonatomic, readonly) NSString *event_type; //关联关系中活动的类型 
@property(nonatomic, readonly) NSString *broad_sdate; //关联关系中活动的推广开始时间
@property(nonatomic, readonly) NSString *broad_edate; //关联关系中活动的推广结束时间 
@property(nonatomic, readonly) NSString *event_sdate; //关联关系中活动的开始时间 
@property(nonatomic, readonly) NSString *event_edate; //关联关系中活动的结束时间 
@property(nonatomic, readonly) NSString *event_source; //关联关系中活动的来源标识 
@property(nonatomic, readonly) NSString *event_source_wapurl;  //关联关系中活动的来源wap地址 
@property(nonatomic, readonly) NSString *event_mobile_logourl; //关联关系中活动的小图地址 
@property(nonatomic, readonly) NSString *event_web_logourl;  //关联关系中的活动的大图地址 
@property(nonatomic, readonly) NSString *longitude; //关联关系中活动举行第的经度 
@property(nonatomic, readonly) NSString *latitude; //关联关系中活动举行地的维度 
@property(nonatomic, readonly) NSString *description;   //关联关系中活动的描述 
@property(nonatomic, readonly) NSString *poi_type;//关联关系中活动的地点类型 
@property(nonatomic, readonly) NSString *group_buy_id; //团购类型活动 ,对象唯一标识ID 
@property(nonatomic, readonly) NSString *group_buy_original_price;  //原价 ，适用于团购类型活动 
@property(nonatomic, readonly) NSString *group_buy_current_price; //现价 ，适用于团购类型活动 
@property(nonatomic, readonly) NSString * group_buy_rate;  //折扣 ，适用于团购类型活动 
@property(nonatomic, readonly) NSString * group_buy_spare; //节省 ，适用于团购类型活动 
@property(nonatomic, readonly) NSString *event_id; //eventId 
@end



///RMPlaceFeedList 获取某个poi或者某个经纬度附近的新鲜事 按poi取的时候不包括此poi信息
@interface RMPlaceFeedList : RMObject{
	 NSString * add_time;///添加时间的毫秒数
	 NSInteger data_type;///类型（1，状态；2，图片；3，签到；4，评价）
	 NSInteger distance;///距离
	 NSString *head_url;///用户头像
	 NSString * latitude_gps;///GPS维度
	 NSString * latitude_poi;///POI维度
	 NSString * locate_type;///位置类型
	 NSString * longitude_gps;///GPS经度
	 NSString * longitude_poi;///POI经度
	 NSString *main_url;///主页地址
	 NSString *user_name;///用户名
	 NSString *pid;///pid
	 NSString *poi_address;///POI地址 
	 NSString *poi_name;///POI名称
	 NSString *poi_phone;///poi电话
	 NSInteger privacy;///隐私
	 NSString *status_text;///状态
	 NSString *tiny_url;///小头像地址
	 NSString * user_id;///用户ID
	 NSInteger reply_count;///回复数
	 NSString *feed_image_url;///新鲜事头像地址
	 NSString * source_id;///新鲜事id
	 RMStatusForward *status_forward;///当新鲜事为状态并且该状态为转发时，转发状态的原状态
	 NSInteger origin_type;///来源类型
     NSString *origin_title;///来源文本
     NSString *origin_url;///来源链接
     NSString * media_id;///照片id
     NSMutableArray *attachement_list;///当新鲜事来源为照片时
     NSString * lbs_id;///当地点为门址时，且类型为状态或图片时对应lbs数据id
     NSString *title;///照片所属相册
     NSString *prefix;///操作内容
}
@property(nonatomic, readonly) NSString * add_time;
@property(nonatomic, readonly) NSInteger data_type;
@property(nonatomic, readonly) NSInteger distance;
@property(nonatomic, readonly) NSString *head_url;
@property(nonatomic, readonly) NSString * latitude_gps;
@property(nonatomic, readonly) NSString * latitude_poi;
@property(nonatomic, readonly) NSString * locate_type;
@property(nonatomic, readonly) NSString * longitude_gps;
@property(nonatomic, readonly) NSString * longitude_poi;
@property(nonatomic, readonly) NSString *main_url;
@property(nonatomic, readonly) NSString *user_name;
@property(nonatomic, readonly) NSString *pid;
@property(nonatomic, readonly) NSString *poi_address;
@property(nonatomic, readonly) NSString *poi_name;
@property(nonatomic, readonly) NSString *poi_phone;
@property(nonatomic, readonly) NSInteger privacy;
@property(nonatomic, readonly) NSString *status_text;
@property(nonatomic, readonly) NSString *tiny_url;
@property(nonatomic, readonly) NSString * user_id;
@property(nonatomic, readonly) NSInteger reply_count;
@property(nonatomic, readonly) NSString *feed_image_url;
@property(nonatomic, readonly) NSString * source_id;
@property(nonatomic, readonly) RMStatusForward *status_forward;
@property(nonatomic, readonly) NSInteger origin_type;
@property(nonatomic, readonly) NSString *origin_title;
@property(nonatomic, readonly) NSString *origin_url;
@property(nonatomic, readonly) NSString * media_id;
@property(nonatomic, readonly) NSMutableArray *attachement_list;
@property(nonatomic, readonly) NSString * lbs_id;
@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *prefix;
@end



@interface RMPoiInfo : RMObject{
	NSString *lon;///经度
	NSString *address;///地址
	NSString *county;///郡县
	NSString *province;///省
	NSString *street_name;///街道
	NSString *nation;///国家
    NSString *lat;///维度
	NSString *city;///城市
}
@property(nonatomic, readonly) NSString *lon;
@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSString *county;
@property(nonatomic, readonly) NSString *province;
@property(nonatomic, readonly) NSString *street_name;
@property(nonatomic, readonly) NSString *nation;
@property(nonatomic, readonly) NSString *lat;
@property(nonatomic, readonly) NSString *city;
@end



@interface RMPoiDataExtra : RMObject{
     NSString * ExtraId ;          
     NSString * pid ;
     NSString * longitude ;           /// 偏转经度
     NSString * latitude ;            /// 偏转纬度
     NSString * longitudeGps ;        /// GPS经度
     NSString * latitudeGps ;         /// GPS 纬度
     NSString * name ;                /// POI名称
     NSString * address ;             /// 地址
     NSString * phone ;               /// 电话
     NSString * note ;               /// 说明
     NSString * country ;            /// 国家
     NSString * province ;           /// 省
     NSString * city ;               /// 市
     NSString * cityCode ;           /// 区号
     NSString * district ;           /// 区
     NSString * street ;             /// 街道
     NSInteger sourceType ;          /// 来源于哪个图商
     NSString * poiCaption ;         /// 供活动使用-非XOA返回数据
     NSString * poiType ;            /// POI类型,比如餐饮、娱乐、文化设施
     NSInteger ugc ;                 /// 外界设置并调用
     NSInteger friendsPointsCount ;  /// POI上好友发布的点评数量
     NSInteger friendsPhotoCount ;   /// POI上好友发布的照片数量
     NSInteger friendsVisited ;      /// 好友来过的次数
     NSInteger totalVistited ;       /// 总的来访次数
     NSInteger hasActivity ;         /// POI是否有活动优惠(现在没有设置该值，判断活动有客户端单独调用活动接口判断)
    
    NSMutableArray *latestFriendsPhotosList;  //POI上好友最新发布的照片
    NSMutableArray *latestFriendsPointsList;  //POI上好友最新发布的点评
    
}
@property(nonatomic, readonly) NSString * ExtraId ;          
@property(nonatomic, readonly) NSString * pid ;
@property(nonatomic, readonly) NSString * longitude ;           // 偏转经度
@property(nonatomic, readonly) NSString * latitude ;            // 偏转纬度
@property(nonatomic, readonly) NSString * longitudeGps ;        // GPS经度
@property(nonatomic, readonly) NSString * latitudeGps ;         // GPS 纬度
@property(nonatomic, readonly) NSString * name ;                // POI名称
@property(nonatomic, readonly) NSString * address ;             // 地址
@property(nonatomic, readonly) NSString * phone ;               // 电话
@property(nonatomic, readonly) NSString * note ;               // 说明
@property(nonatomic, readonly) NSString * country ;            // 国家
@property(nonatomic, readonly) NSString * province ;           // 省
@property(nonatomic, readonly) NSString * city ;               // 市
@property(nonatomic, readonly) NSString * cityCode ;           // 区号
@property(nonatomic, readonly) NSString * district ;           // 区
@property(nonatomic, readonly) NSString * street ;             // 街道
@property(nonatomic, readonly) NSInteger sourceType ;          // 来源于哪个图商
@property(nonatomic, readonly) NSString * poiCaption ;         // 供活动使用-非XOA返回数据
@property(nonatomic, readonly) NSString * poiType ;            // POI类型,比如餐饮、娱乐、文化设施
@property(nonatomic, readonly) NSInteger ugc ;                 // 外界设置并调用
@property(nonatomic, readonly) NSInteger friendsPointsCount ;  // POI上好友发布的点评数量
@property(nonatomic, readonly) NSInteger friendsPhotoCount ;   // POI上好友发布的照片数量
@property(nonatomic, readonly) NSInteger friendsVisited ;      // 好友来过的次数
@property(nonatomic, readonly) NSInteger totalVistited ;       // 总的来访次数
@property(nonatomic, readonly) NSInteger hasActivity ;
@property(nonatomic, readonly) NSMutableArray *latestFriendsPhotosList; //POI上好友最新发布的照片
@property(nonatomic, readonly) NSMutableArray *latestFriendsPointsList; //POI上好友最新发布的点评
@end




@interface RMLocationFlowLite : RMObject{
    NSInteger locationFlowLiteId;
    NSInteger userId;
    NSString  *userName;
    NSInteger srcId;
    NSString *content;
    NSInteger bizType;    
}

@property(nonatomic, readonly) NSInteger locationFlowLiteId;          
@property(nonatomic, readonly) NSInteger userId;
@property(nonatomic, readonly) NSString *userName;          
@property(nonatomic, readonly) NSInteger srcId;         
@property(nonatomic, readonly) NSString *content;      
@property(nonatomic, readonly) NSInteger bizType;    

@end


@interface RMLocationFlowPhoto : RMObject{
    NSInteger photo_id;
	NSInteger album_id;
	NSString *album_name;
	NSString *title;
	NSString *large_url;
	NSString *main_url;
	NSString *head_url;
	NSString *tiny_url;
    
}

@property(nonatomic, readonly)NSInteger photo_id;
@property(nonatomic, readonly)NSInteger album_id;
@property(nonatomic, readonly)NSString *album_name;
@property(nonatomic, readonly)NSString *title;
@property(nonatomic, readonly)NSString *large_url;
@property(nonatomic, readonly)NSString *main_url;
@property(nonatomic, readonly)NSString *head_url;
@property(nonatomic, readonly)NSString *tiny_url;

@end

@interface RMSourceTypeAppid : RMObject{
    NSInteger app_id;
	NSInteger source_type;
	NSString *source_url;
	NSInteger feed_reply_type;
	NSString *source_name;
}

@property(nonatomic, readonly)NSInteger app_id;
@property(nonatomic, readonly)NSInteger source_type;
@property(nonatomic, readonly)NSString *source_url;
@property(nonatomic, readonly)NSInteger feed_reply_type;
@property(nonatomic, readonly)NSString *source_name;

@end

@interface RMDoingInfo : RMObject{
    NSInteger Id;
	NSInteger user_id;
	NSString *content;
	NSString *the_new_content;
	NSString *the_root_content;
	NSString *html_new_content;
	NSString *html_root_content;
	NSString *is_forward;
	NSString *is_position;
	NSInteger root_doing_user_id;
	NSString *root_doing_user_name;
}

@property(nonatomic, readonly)NSInteger Id;
@property(nonatomic, readonly)NSInteger user_id;
@property(nonatomic, readonly)NSString *content;
@property(nonatomic, readonly)NSString *the_new_content;
@property(nonatomic, readonly)NSString *the_root_content;
@property(nonatomic, readonly)NSString *html_new_content;
@property(nonatomic, readonly)NSString *html_root_content;
@property(nonatomic, readonly)NSString *is_forward;
@property(nonatomic, readonly)NSString *is_position;
@property(nonatomic, readonly)NSInteger root_doing_user_id;
@property(nonatomic, readonly)NSString *root_doing_user_name;

@end

@interface RMPoidataInfoList : RMObject{
    NSString *pid;                                    
	NSString *poi_data_id ;
	NSString *poi_data_pid ;
	NSString *poi_data_longitude ; // 偏转经度
	NSString *poi_data_latitude;  // 偏转纬度
	NSString *poi_data_longitudeGps; // GPS经度
    NSString *poi_data_latitudeGps;  // GPS 纬度
    NSString *poi_data_name ;    // POI名称
    NSString * poi_data_address ;  // 地址
    NSString *poi_data_phone ; // 电话
    NSString *poi_data_note ;  // 说明
    NSString *poi_data_country ; // 国家
    NSString *poi_data_province ; // 省
    NSString * poi_data_city ;  // 市
    NSString *poi_data_city_code ;  // 区号
    NSString *poi_data_district ;  // 区
    NSString *poi_data_street ; // 街道
    NSString *poi_data_source_type ; // 来源于哪个图商
    NSString *poi_data_poi_caption ; // 供活动使用-非XOA返回数据
    NSString *poi_data_poi_type ;  // POI类型,比如餐饮、娱乐、文化设施
    NSString *poi_data_ugc ; // 外界设置并调用,返回值只有 true/false 两种结果
    NSString *poi_data_source ;  //兴趣点来源标识ID    
}

@property(nonatomic, readonly) NSString *pid;                                    
@property(nonatomic, readonly) NSString *poi_data_id ;
@property(nonatomic, readonly) NSString *poi_data_pid ;
@property(nonatomic, readonly) NSString *poi_data_longitude ; // 偏转经度
@property(nonatomic, readonly) NSString *poi_data_latitude;  // 偏转纬度
@property(nonatomic, readonly) NSString *poi_data_longitudeGps; // GPS经度
@property(nonatomic, readonly) NSString *poi_data_latitudeGps;  // GPS 纬度
@property(nonatomic, readonly) NSString *poi_data_name ;    // POI名称
@property(nonatomic, readonly) NSString * poi_data_address ;  // 地址
@property(nonatomic, readonly) NSString *poi_data_phone ; // 电话
@property(nonatomic, readonly) NSString *poi_data_note ;  // 说明
@property(nonatomic, readonly) NSString *poi_data_country ; // 国家
@property(nonatomic, readonly) NSString *poi_data_province ; // 省
@property(nonatomic, readonly) NSString * poi_data_city ;  // 市
@property(nonatomic, readonly) NSString *poi_data_city_code ;  // 区号
@property(nonatomic, readonly) NSString *poi_data_district ;  // 区
@property(nonatomic, readonly) NSString *poi_data_street ; // 街道
@property(nonatomic, readonly) NSString *poi_data_source_type ; // 来源于哪个图商
@property(nonatomic, readonly) NSString *poi_data_poi_caption ; // 供活动使用-非XOA返回数据
@property(nonatomic, readonly) NSString *poi_data_poi_type ;  // POI类型,比如餐饮、娱乐、文化设施
@property(nonatomic, readonly) NSString *poi_data_ugc ; // 外界设置并调用,返回值只有 true/false 两种结果
@property(nonatomic, readonly) NSString *poi_data_source ;  //兴趣点来源标识ID     
@end


@interface RMLbsFeedInfo : RMObject{
    NSInteger locationFlowLiteId;
    NSInteger userId;
    NSString  *userName;
    NSString  *gender;
	NSString  *head_url;
	NSInteger reply_count;
	NSInteger ugc_type;
	NSInteger ugc_id;
	NSString  *pid;
	NSString  *longitude;
	NSString  *latitude;
	NSString  *location_name;
	NSInteger biz_type;
	NSInteger biz_sub_type;
	NSInteger src_id;
	NSInteger loc_type;
	NSString  *content;
	NSString  *ubb_content;
	NSInteger privacy;
	NSString  *grid_id2;
	NSString  *grid_id3;
	NSString  *grid_id4;
	NSInteger src_time;
	NSInteger add_time;
	NSInteger add_user_id;
	NSInteger modify_time;
	NSInteger modify_user_id;
	NSString  *remark;
	RMSourceTypeAppid *source_type_appid;
    NSMutableArray *location_flow_photo;
	NSMutableArray *doing_info;
    
}

@property(nonatomic, readonly)NSInteger locationFlowLiteId;
@property(nonatomic, readonly)NSInteger userId;
@property(nonatomic, readonly)NSString  *userName;
@property(nonatomic, readonly)NSString  *gender;
@property(nonatomic, readonly)NSString  *head_url;
@property(nonatomic, readonly)NSInteger reply_count;
@property(nonatomic, readonly)NSInteger ugc_type;
@property(nonatomic, readonly)NSInteger ugc_id;
@property(nonatomic, readonly)NSString  *pid;
@property(nonatomic, readonly)NSString  *longitude;
@property(nonatomic, readonly)NSString  *latitude;
@property(nonatomic, readonly)NSString  *location_name;
@property(nonatomic, readonly)NSInteger biz_type;
@property(nonatomic, readonly)NSInteger biz_sub_type;
@property(nonatomic, readonly)NSInteger src_id;
@property(nonatomic, readonly)NSInteger loc_type;
@property(nonatomic, readonly)NSString  *content;
@property(nonatomic, readonly)NSString  *ubb_content;
@property(nonatomic, readonly)NSInteger privacy;
@property(nonatomic, readonly)NSString  *grid_id2;
@property(nonatomic, readonly)NSString  *grid_id3;
@property(nonatomic, readonly)NSString  *grid_id4;
@property(nonatomic, readonly)NSInteger src_time;
@property(nonatomic, readonly)NSInteger add_time;
@property(nonatomic, readonly)NSInteger add_user_id;
@property(nonatomic, readonly)NSInteger modify_time;
@property(nonatomic, readonly)NSInteger modify_user_id;
@property(nonatomic, readonly)NSString  *remark;
@property(nonatomic, readonly)RMSourceTypeAppid *source_type_appid;
@property(nonatomic, readonly)NSMutableArray *location_flow_photo;
@property(nonatomic, readonly)NSMutableArray *doing_info;


@end