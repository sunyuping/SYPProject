//
//  RichTextKitViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-4-10.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTStyledTextLabel.H"


@interface RichTextKitViewController : UIViewController<RTKDocumentDelegate>{
    TTStyledTextLabel* _chatMessageLabel;
    
}

@property (nonatomic,retain)TTStyledTextLabel* chatMessageLabel;


@end
