//
//  TestSocketViewController.h
//  SYPProject
//
//  Created by sunyuping on 13-4-27.
//
//

#import <UIKit/UIKit.h>

@class GCDAsyncSocket;


@interface TestSocketViewController : UIViewController
{
	GCDAsyncSocket *asyncSocket;
    dispatch_queue_t delegateQueue;
	
	dispatch_queue_t socketQueue;
}
@end
