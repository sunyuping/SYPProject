//
//  TestTableViewController.h
//  SYPProject
//
//  Created by sunyuping on 12-10-31.
//
//

#import <UIKit/UIKit.h>

@interface TestTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableview;
}
@property (nonatomic, retain)  UITableView *tableview;
@end
