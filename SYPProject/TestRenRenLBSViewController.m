//
//  TestRenRenLBSViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-3-21.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "TestRenRenLBSViewController.h"
#import "RMConnectCenter.h"
#import "RMConnectCenter+Login.h"

@interface TestRenRenLBSViewController ()

@end

@implementation TestRenRenLBSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //登陆客户端
    testNum =0;
    UIButton *loginbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginbutton setTitle:@"登陆账号" forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    loginbutton.frame = CGRectMake(10, 10, 80, 30);
    [self.view addSubview:loginbutton];
    
    UIButton *autotest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [autotest setTitle:@"自动测试" forState:UIControlStateNormal];
    [autotest addTarget:self action:@selector(autotest) forControlEvents:UIControlEventTouchDown];
    autotest.frame = CGRectMake(100, 10, 80, 30);
    [self.view addSubview:autotest];
    
    _result =[[UITextView alloc]initWithFrame:CGRectMake(10, 50, 320, 400)];
    [self.view addSubview:_result];
    
}
-(void)login{
    if (![RMConnectCenter isCurrentUserLogined]){
    [[RMConnectCenter  sharedCenter] launchDashboardLoginWithDelegate:(id<RenrenLoginViewControllerDelegate>)self];
    }
}
-(void)testwithNumber:(NSInteger)p_count{
    
    switch (p_count) {
        case 0:
            if(setStatusContext)
            {
                [setStatusContext release];
                setStatusContext = nil;
            }
            setStatusContext=[[RMSetStatusContext alloc] init];
            [setStatusContext setDelegate:self];
            NSString *lbs=@"{\"source_type\":\"2\",\"place_name\":\"王府井步行街\",\"gps_longitude\":\"116405296\",\"gps_latitude\":\"39905523\",\"place_latitude\":\"39905523\",\"locate_type\":\"1\",\"place_location\":\"\",\"place_id\":\"B000A48169\",\"place_longitude\":\"116405296\",\"privacy\":\"2\"}";
            setStatusContext.placeData=lbs;
            [setStatusContext asynSetStatus:@"LBS Demo Test"];
            break;
        case 1:
            if(photosUploadbinContext)
            {
                [photosUploadbinContext release];
                photosUploadbinContext = nil;
            }
            photosUploadbinContext = [[RMPhotosUploadbinContext alloc] init];
            [photosUploadbinContext setDelegate:self];
            [photosUploadbinContext asynPhotosUploadbinWithImage:[UIImage imageNamed:@"bgLogo.png"]];
            break;
        case 2:
            if(getPoiCategoryContext)
            {
                [getPoiCategoryContext release];
                getPoiCategoryContext = nil;
            }
            getPoiCategoryContext= [[RMPlaceGetPoiCategoryContext alloc] init];
            [getPoiCategoryContext setDelegate:self];
            [getPoiCategoryContext asynGetPoiCategory];
            break;
        case 3:
            if(placePoiListContext)
            {
                [placePoiListContext release];
                placePoiListContext = nil;
            }
            placePoiListContext= [[RMPlacePoiListContext alloc] init];
            [placePoiListContext setDelegate:self];
            placePoiListContext.page = 1;
            placePoiListContext.pageSize = 10;
            placePoiListContext.k = @"";
            
            [placePoiListContext asynPoiList:@"37785834" lonGps:@"122406417" radius:1 d:1];
            
            break;
        case 4:
            if(poiExtraListContext)
            {
                [poiExtraListContext release];
                poiExtraListContext = nil;
            }
            poiExtraListContext= [[RMPlaceGetNearByRecommendPoiExtraListContext alloc] init];
            [poiExtraListContext setDelegate:self];
            poiExtraListContext.page = 1;
            poiExtraListContext.pageSize = 10;
            poiExtraListContext.radius = 2000;
            poiExtraListContext.type = -1;
            
            [poiExtraListContext asynGetRecommendPoiExtraList:@"39960030" lonGps:@"116440400 " d:1];
            
            break;
        default:
            break;
    }

}
-(void)autotest{
    testNum = 0;
    [self testwithNumber:0];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)doLog:(NSString*)log{
    _result.text = [NSString stringWithFormat:@"%@%@",_result.text,log];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/**
 * 当RequestContext异步发送请求开始时触发此回调。
 */ 
- (void)contextDidStartLoad:(id) context
{
    NSLog(@"contextDidStartLoad");
}

/**
 * 当RequestContext异步请求结束，成功返回数据时触发此回调，并调用context的response查看回调
 */ 
- (void)contextDidFinishLoad:(id) context
{
    testNum++;
    NSString *logString = nil;
    if([context isKindOfClass:[RMSetStatusContext class]])
    {
        logString = [NSString stringWithFormat:@"返回的结果是: %@\n", [setStatusContext getContextResponse].result];
        [self doLog:logString];
    }
    if([context isKindOfClass:[RMPhotosUploadbinContext class]])
    {
        logString = [NSString stringWithFormat:@"返回的结果是: %@\n",[photosUploadbinContext getContextResponse].photoId];
        [self doLog:logString];
    }
    if([context isKindOfClass:[RMPlacePoiListContext class]])
    {
        
        NSMutableArray *conpoilist = [placePoiListContext getContextResponse].poiList;
        RMPoiListItem *info =  [placePoiListContext getContextResponse].info;
        logString = [NSString stringWithFormat:@"返回的结果是: %d\n",[placePoiListContext getContextResponse].count];
        [self doLog:logString];
        for (RMCategory* aresult in conpoilist ){
            [self doLog:[NSString stringWithFormat:@"id=@,name=%@",aresult.categoryId,aresult.categoryName]];
        }
    }
    if([context isKindOfClass:[RMPlaceGetNearByRecommendPoiExtraListContext class]])
    {
        
        NSMutableArray *list= [getPoiCategoryContext getContextResponse].category_list;
        logString = [NSString stringWithFormat:@"返回的结果是: %d\n",[poiExtraListContext getContextResponse].count];
        [self doLog:logString];
        for (RMCategory* aresult in list ){
            [self doLog:[NSString stringWithFormat:@"id=@,name=%@",aresult.categoryId,aresult.categoryName]];
        }
    }
    if([context isKindOfClass:[RMPlaceGetPoiCategoryContext class]])
    {
        NSMutableArray *list= [getPoiCategoryContext getContextResponse].category_list;
        logString = [NSString stringWithFormat:@"返回的结果是: %d\n",[getPoiCategoryContext getContextResponse].count];
        [self doLog:logString];
        for (RMCategory* aresult in list ){
            [self doLog:[NSString stringWithFormat:@"id=@,name=%@",aresult.categoryId,aresult.categoryName]];
        }
    }
    [self testwithNumber:testNum];
}

/**
 * 当RequestContext异步请求失败时触发此回调，error的错误可能有网络错误，服务错误。
 */ 
- (void)context:(id) context didFailLoadWithError:(RMError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
    if([context isKindOfClass:[RMSetStatusContext class]])
    {
        [setStatusContext release];
        setStatusContext = nil;
    }
    else if([context isKindOfClass:[RMPhotosUploadbinContext class]])
    {
        [photosUploadbinContext release];
        photosUploadbinContext = nil;
    }
    if([context isKindOfClass:[RMPlacePoiListContext class]])
    {
        [placePoiListContext release];
        placePoiListContext = nil;
    }
    if([context isKindOfClass:[RMPlaceGetNearByRecommendPoiExtraListContext class]])
    {
        [poiExtraListContext release];
        poiExtraListContext = nil;
    }
    if([context isKindOfClass:[RMPlaceGetPoiCategoryContext class]])
    {
        [getPoiCategoryContext release];
        getPoiCategoryContext = nil;
    }
}

/**
 * 当RequestContext异步请求取消时，context主动调用了cancel方法会触发此回调
 */
- (void)contextDidCancelLoad:(id)context
{
    NSLog(@"contextDidCancelLoad");
    
    if([context isKindOfClass:[RMSetStatusContext class]])
    {
        [setStatusContext release];
        setStatusContext = nil;
    }  
    if([context isKindOfClass:[RMPhotosUploadbinContext class]])
    {
        [photosUploadbinContext release];
        photosUploadbinContext = nil;
    }
    if([context isKindOfClass:[RMPlacePoiListContext class]])
    {
        [placePoiListContext release];
        placePoiListContext = nil;
    }
    if([context isKindOfClass:[RMPlaceGetNearByRecommendPoiExtraListContext class]])
    {
        [poiExtraListContext release];
        poiExtraListContext = nil;
    }
    if([context isKindOfClass:[RMPlaceGetPoiCategoryContext class]])
    {
        [getPoiCategoryContext release];
        getPoiCategoryContext = nil;
    }
}

@end
