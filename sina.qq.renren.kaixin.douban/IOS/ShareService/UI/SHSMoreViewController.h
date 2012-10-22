//
//  MoreViewController.h
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSCore.h"
#import "SHSShareViewController.h"

@interface SHSMoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView; 
}

@property (nonatomic,assign) SHSShareViewController *parentController;
@property (nonatomic,retain) NSArray * moreActions;
@property (nonatomic,retain) NSArray * moreServices;

- (void)cancelMoreView;

@end
