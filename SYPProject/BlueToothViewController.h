//
//  BlueToothViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#define START_GAME_KEY @"startgame"
#define END_GAME_KEY @"endgame"
#define TAP_COUNT_KEY @"taps"
#define WINNING_TAP_COUNT 50
#define AMIPHD_P2P_SESSION_ID @"amiphdp2p2"//这个是蓝牙协议

@interface BlueToothViewController : UIViewController<GKPeerPickerControllerDelegate,GKSessionDelegate>{
    GKPeerPickerController *_picker;
    GKSession *_session;
    UILabel *_connectstate;
    UIButton *_sendDataButton;
    NSMutableData *_data;
}

@end
