//
//  DemoTableViewController.h
//  SYPProject
//
//  Created by sunyuping on 12-11-14.
//
//

#import <UIKit/UIKit.h>


typedef enum
{
    DemoTableViewStyle_Cyan = 0,
    DemoTableViewStyle_Green = 1,
    DemoTableViewStyle_Purple = 2,
    DemoTableViewStyle_Yellow = 3,
    DemoTableViewStyle_2Colors = 4,
    DemoTableViewStyle_3Colors = 5,
    DemoTableViewStyle_DottedLine = 6,
    DemoTableViewStyle_Dashes = 7,
    DemoTableViewStyle_GradientVertical = 8,
    DemoTableViewStyle_GradientHorizontal = 9,
    DemoTableViewStyle_GradientDiagonalTopLeftToBottomRight = 10,
    DemoTableViewStyle_GradientDiagonalBottomLeftToTopRight = 11,
} DemoTableViewStyle;

@interface DemoTableViewController : UITableViewController

@property (assign, nonatomic) DemoTableViewStyle demoTableViewStyle;

@end
