//
//  PopupVC.h
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

//#import "ViewController.h"
#import <UIKit/UIKit.h>

//@class PopupVC;

//@protocol PopupDelegate <NSObject>
//@optional
//- (void)popup:(PopupVC *)vc didClickYes:(id)sender;
//- (void)popup:(PopupVC *)vc didClickCancel:(id)sender;
//@end

//@interface PopupVC : ViewController
@interface PopupVC : UIViewController
{
    IBOutlet UILabel *textLabel;
    IBOutlet UIButton *yesButton;
    IBOutlet UIButton *cancelButton;
}

//@property (nonatomic, weak) id<PopupDelegate> delegate;
@property (nonatomic) int tag;
@property (nonatomic, strong) NSString *message;

//typedef BOOL(^PopupCallback)(UIViewController * sender);
//@property (nonatomic, strong) PopupCallback callback;

typedef void(^CancelBlock)(UIButton *sender);
@property (nonatomic, strong) CancelBlock cancelBlock;

typedef void(^YesBlock)(UIButton *sender);
@property (nonatomic, strong) YesBlock yesBlock;


@end
