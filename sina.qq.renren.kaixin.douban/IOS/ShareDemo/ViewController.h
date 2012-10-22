//
//  ViewController.h
//  ShareDemo
//
//  Created by tmy on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSShareViewController.h"

@interface ViewController : UIViewController
{
    SHSShareViewController *shareController;
    IBOutlet UITextField *textField;
    IBOutlet UIImageView *imageView;
    IBOutlet UISwitch *imageSwith;
}
- (IBAction)share:(id)sender;
- (IBAction)showEditor:(id)sender;
@end
