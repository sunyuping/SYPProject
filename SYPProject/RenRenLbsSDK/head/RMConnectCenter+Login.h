//
//  RMConnectCenter+Login.h
//  RMTinyClient
//
//  Created by Shum Louie on 2/10/12.
//  Copyright (c) 2012 人人网. All rights reserved.
//
#import "RMConnectCenter.h"

@interface RMConnectCenter (Login)

/**
 *zh
 * 启动登录人人网的功能界面，让用户登录人人网
 *
 *en
 *start the login interface of renren to allow users to sign in
 */ 
- (void)launchDashboardLoginWithDelegate:(id<RenrenLoginViewControllerDelegate>)delegate;

@end

