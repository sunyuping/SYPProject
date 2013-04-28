//
//  TestSocketViewController.m
//  xingyun
//
//  Created by sunyuping on 13-4-28.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "TestSocketViewController.h"
#import "GCDAsyncSocket.h"
#import "JSONKit.h"
#import "NSData+CocoaDevUsersAdditions.h"



//#define HOST @"10.0.1.100"
#define HOST @"10.0.1.96"
#define PORT 9999

@interface TestSocketViewController ()

@end

@implementation TestSocketViewController

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
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
	
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)aaa{
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
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    NSData *unzipData = [data gzipInflate];
	NSString *httpResponse = [[NSString alloc] initWithData:unzipData encoding:NSUTF8StringEncoding];
    
	NSLog(@"HTTP Response:\n%@", httpResponse);
	[sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}
static int socketid = 1;

-(void)testauthenticate{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"xy_%d",socketid++],@"id", [NSNumber numberWithInt:1],@"type",nil];
    
    NSData *datainfo = [dic JSONData];
    [asyncSocket writeData:[datainfo gzipDeflate] withTimeout:-1 tag:1];
}

//-(void)testMessageSuccess{
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%xy_d",socketid++],@"id", [NSNumber numberWithInt:0],@"type",nil];
//
//}

@end





