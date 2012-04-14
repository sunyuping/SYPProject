//
//  Test_MKNetworkKit.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Test_MKNetworkKit.h"
#import "RRUIImageView.h"
//http://ic.m.renren.com/gn?op=resize&w=50&h=50&p=
@implementation Test_MKNetworkKit
-(void)dealloc{
    [super dealloc];
    [myengine release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *tmpbutton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tmpbutton addTarget:self action:@selector(testbuttonclick) forControlEvents:UIControlEventTouchDown];
    [tmpbutton setFrame:CGRectMake(10, 0, 200, 100)];
    [tmpbutton setTitle:@"测试下载数据" forState:UIControlStateNormal];
    [self.view addSubview:tmpbutton];
   // myengine = [[MKNetworkEngine alloc] initWithHostName:@"api.m.renren.com" customHeaderFields:nil];
    myengine = [[MKNetworkEngine alloc] initWithHostName:@"mp3.baidu.com/" customHeaderFields:nil];
    [myengine useCache];

}
-(void)didfinshed:(NSData*)respon{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    RRLOGI("syp===%@", [[[NSString alloc] initWithData:respon encoding:enc] autorelease]);

}
-(void)neterr:(NSError*)err{
    
    RRLOGI("syp====error=%d",err.code);
}
-(void)testnet{
    for (int i=0; i<10; i++) {
        MKNetworkOperation *op = [myengine operationWithPath:@"" //api/client/login
                                                      params:nil 
                                                  httpMethod:@"GET"];
        [op onCompletion:^(MKNetworkOperation *completedOperation)
         {
             if([completedOperation isCachedResponse]) {
                 DLog(@"syp==cache==Data from cache %@", [completedOperation responseJSON]);
             }
             else {
                 DLog(@"syp==server==Data from server %@", [completedOperation responseString]);
             }
             [self didfinshed:completedOperation.responseData];
             
         }onError:^(NSError* error) {
             [self neterr:error];
         }];
        [myengine enqueueOperation:op];
    }
   
    UIScrollView *testscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100,[[UIScreen mainScreen] bounds].size.width , [[UIScreen mainScreen] bounds].size.height - 150)];
    testscrollview.scrollEnabled = YES;
    [testscrollview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:testscrollview];
    [testscrollview release];
    NSMutableArray *urlarr = [NSMutableArray arrayWithObjects:@"http://www.025ct.com/uploads/allimg/110421/255-110421141140.jpg",@"http://img3.yxlady.com/yl/UploadFiles_5361/20100929/2010092916150588.jpg",@"http://www.jzrt.com/uploads/cj/2011/20110602/2011060218004415802.jpg",@"http://www.swddd.com/uploadfile/2010/0508/20100508085539900.jpg",@"http://img.ycwb.com/women/attachement/jpg/site2/20110713/0021976ebb3c0f873c0144.jpg",@"http://i.baidu.com/yule/r/image/2008-11-14/dffaba0c4c3c7f73f1f8c3d2de026baf.jpg",@"http://ent.v1.cn/images/2010-11-30/201011301291079815972_755.png",@"http://pic.66wz.com/0/00/13/95/139523_157210.jpg", nil];
    int image_w = 80;
    int image_h = 80;
    int scrviewe_w=[[UIScreen mainScreen] bounds].size.width;
    int size_h = 0;
    for (int i=0,y=0,z=0,urlid = 0; i<40; i++) {
        
        RRUIImageView *mytestimage =  [[RRUIImageView alloc] initWithFrame:CGRectMake(z*image_w, y*image_h, image_w, image_h)];
        [mytestimage setImageWithUrl:[urlarr objectAtIndex:urlid]];
        [testscrollview addSubview:mytestimage];
        [mytestimage release];
        z++;
        urlid++;
        if (z*image_w >= scrviewe_w) {
            z=0;
            y++;
            size_h = (y+1)*image_h;
        }
        if (urlid >=[urlarr count]) {
            urlid = 0;
        }
    
    }
    [testscrollview setContentSize:CGSizeMake(scrviewe_w, size_h)];
}
-(void)testbuttonclick{
    NSString *clintinfo = [NSString stringWithFormat:@"{\"model\":\"iPod touch\", \"os\":\"iPhone OS5.1\", \"uniqid\":\"ff586779398efa8bf055a88899db5b5d6057fd20\", \"screen\":\"768x1024\", \"font\":\"system 12\", \"ua\":\"xiaonei_iphone4.5.5\", \"from\":\"2000505\", \"version\":\"4.5.5\"}"];
    NSMutableDictionary *body = [[[NSMutableDictionary alloc] init] autorelease];
    [body setObject:@"982f1025964b461099ac889453b700d1" forKey:@"api_key"];
    [body setObject:@"1.0" forKey:@"v"];
    [body setObject:@"client.login" forKey:@"method"];
    [body setObject:@"76922144" forKey:@"uni_qid"];
    [body setObject:@"15101624408" forKey:@"user"];
    [body setObject:@"woaini04051001" forKey:@"password"];
    [body setObject:@"json" forKey:@"format"];
    [body setObject:clintinfo forKey:@"client_info"];
    RRLOGI("ssssssssss=%@",body);
    [self testnet];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
