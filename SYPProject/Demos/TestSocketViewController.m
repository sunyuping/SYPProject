//
//  TestSocketViewController.m
//  SYPProject
//
//  Created by sunyuping on 13-5-6.
//
//

#import "TestSocketViewController.h"
#import "GCDAsyncSocket.h"
#import "RRUtility.h"


#define HOST @"10.0.1.45"
#define PORT 54321

@interface TestSocketViewController ()

@end

@implementation TestSocketViewController

static int socketid = 1;

-(void)dealloc{
    dispatch_release(delegateQueue);
	dispatch_release(socketQueue);
    
    [super dealloc];
}
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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"zip"];
    NSData *filedata = [NSData dataWithContentsOfFile:filePath];
    
    NSData *unzipfiledata = [filedata zlibInflate];
    NSString *httpResponse = [[NSString alloc] initWithData:unzipfiledata encoding:NSUTF8StringEncoding];
    NSLog(@"a.zip data:\n%@", httpResponse);
    
	// Do any additional setup after loading the view.
    //    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    delegateQueue =  dispatch_queue_create("delegateQueue", NULL);  //socket 回调线程
    socketQueue = dispatch_queue_create("socketQueue", NULL);		//socket 内部处理要用的线程
	
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:delegateQueue socketQueue:socketQueue];
    
    NSString *host = HOST;
    uint16_t port = PORT;
    NSLog(@"Connecting to \"%@\" on port %hu...", host, port);
    
    NSError *error = nil;
    if (![asyncSocket connectToHost:HOST onPort:port error:&error])
    {
        NSLog(@"Error connecting: %@", error);
    }
    UIButton *tmp = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmp setTitle:@"test" forState:UIControlStateNormal];
    [tmp setBackgroundColor:[UIColor blackColor]];
    tmp.frame = CGRectMake(10, 10, 100, 100);
    [tmp addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tmp];
    
    //    [asyncSocket readDataToLength:100 withTimeout:-1 tag:1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)aaa{
    //    [asyncSocket writeData:[self testMessageSuccess] withTimeout:-1 tag:2];
    	[RRUtility sendMemoryWarning];
//    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"UISimulatedMemoryWarningNotification", NULL, NULL, true);  
    [self testauthenticate];
    
    
    //    [asyncSocket writeData:[@"100200886003\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
}
#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    [sock readDataWithTimeout:-1 tag:0];
    

}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	NSLog(@"socketDidSecure:%p", sock);
    
	
	NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
	
	[sock writeData:requestData withTimeout:-1 tag:0];
	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
    //     [asyncSocket readDataWithTimeout:-1 tag:tag];
}
static int tmpNumber = 0;
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

    tmpNumber++;
	NSLog(@"socket:%p didReadData:withTag:=================%d", sock, tmpNumber);
    NSData *unzipData = [data zlibInflate];
    if (unzipData == nil || unzipData.length <=0) {
//        NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"aaaaa Response:\n%@", httpResponse);
        [sock readDataWithTimeout:-1 tag:2];
        return;
    }
    
//	NSString *httpResponse = [[NSString alloc] initWithData:unzipData encoding:NSUTF8StringEncoding];
//	NSLog(@"HTTP Response:\n%@", httpResponse);
    
//    NSDictionary *resault = [unzipData objectFromJSONData];
//    
//    NSLog(@"HTTP resault:\n%@", resault);
//    
    
	socketid++;
    [sock readDataWithTimeout:-1 tag:2];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}


-(void)testauthenticate{
//    for (int i=0; i<10000; i++) {
        //唯一的验证
        NSString *keyV = [NSString stringWithFormat:@"xy_asdafsfdgdg"];
        NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:@"dasdsadasdasdas",@"token",[keyV md5],@"v", nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"xy_%d",1],@"id", [NSNumber numberWithInt:1],@"type",msg,@"msg",nil];
        
        NSData *datainfo = [dic JSONData];
        NSMutableData *dataTmp = [NSMutableData dataWithData:datainfo];
        NSData *enterStr =[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
        [dataTmp appendData:enterStr];
        
        [asyncSocket writeData:[dataTmp zlibDeflate] withTimeout:-1 tag:1];
        [asyncSocket readDataWithTimeout:-1 tag:1];
//    }

}

-(NSData*)testMessageSuccess{
    socketid++;
    NSDictionary *msg = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"socket发送消息%d",socketid],@"content",@"200200886009",@"toid", nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%xy_d",socketid],@"id", [NSNumber numberWithInt:10],@"type",msg,@"msg",nil];
    //    return [dic JSONData];
    NSData *datainfo = [dic JSONData];
    NSMutableData *dataTmp = [NSMutableData dataWithData:datainfo];
    NSData *enterStr =[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    [dataTmp appendData:enterStr];
    return [dataTmp zlibDeflate];
}

@end
