//
//  GitDemoViewController.h
//  SYPProject
//
//  Created by sunyuping on 12-10-29.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface GitDemoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>{
    NSMutableArray  *_images;
    UITableView     *_tableView;
}

@property (nonatomic, retain)NSMutableArray *images;
@property (nonatomic, retain)UITableView    *tableView;
@end
