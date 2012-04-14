//
//  BlueToothViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlueToothViewController.h"

@implementation BlueToothViewController
-(void)dealloc{
    [super dealloc];
    [_picker release];
    [_connectstate release];
    [_data release];
    if (_session) {
        [_session release];
    }
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
    _data = [[NSMutableData alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    _picker = [[GKPeerPickerController alloc] init];
    _picker.delegate = self;
    _picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [_picker show];
    _connectstate=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 100)];
    _connectstate.textColor = [UIColor redColor];
    _connectstate.text = @"连接状态";
    [self.view addSubview:_connectstate];
    _sendDataButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_sendDataButton addTarget:self action:@selector(sendData) forControlEvents:UIControlEventTouchDown];
    [_sendDataButton setFrame:CGRectMake(10, 300, 100, 100)];
    [_sendDataButton setTitle:@"发送数据" forState:UIControlStateNormal];
    [self.view addSubview:_sendDataButton];
}
-(void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context{//receiveData:fromPeer:inSession:context
    RRLOGI("syp===receivedata====data==%@",data);
}
-(void)sendData{
    NSData *data = [NSData dataWithBytes:@"ceshi1234567890" length:20];
    NSError *error;
    BOOL didsend = [_session sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
    if (!didsend) {
        RRLOGI("syp=====send==error==%@",[error localizedDescription]);
    }
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
/* Notifies delegate that a connection type was chosen by the user.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type{
     RRLOGI("syp==peerPickerController==didSelectConnectionType=%@",type);
}

/* Notifies delegate that the connection type is requesting a GKSession object.
 
 You should return a valid GKSession object for use by the picker. If this method is not implemented or returns 'nil', a default GKSession is created on the delegate's behalf.
 */
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
    if (!_session) {
        _session = [[GKSession alloc] initWithSessionID:@"syp" displayName:nil sessionMode:GKSessionModePeer];
        _session.delegate = self;
    }
    return _session;
}

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
     RRLOGI("syp==peerPickerController==peerID=%@==didChangeState=%@",peerID,session);
    [_picker dismiss];
    [_session setDataReceiveHandler:self withContext:nil];
    _connectstate.text = @"连接成功";
}

/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
    [_picker dismiss];
}


/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    RRLOGI("syp==session==peerID=%@==didChangeState=%d",peerID,state);
}

/* Indicates a connection request was received from another peer. 
 
 Accept by calling -acceptConnectionFromPeer:
 Deny by calling -denyConnectionFromPeer:
 */
-(void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    RRLOGI("syp==didReceiveConnectionRequestFromPeer==peerID=%@",peerID);
}

/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
 */
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    RRLOGI("syp==connectionWithPeerFailed==error=%@",error);
}

/* Indicates an error occurred with the session such as failing to make available.
 */
- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    RRLOGI("syp==didFailWithError==error=%@",error);
}


@end
