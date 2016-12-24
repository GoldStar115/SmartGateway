//
//  ViewController.h
//  SmartGateway
//
//  Created by Grace on 8/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupVC.h"

@class PopupVC;
@interface ViewController : UIViewController

- (void)popViewController;
- (void)popViewControllerAnimated:(bool)animated;

- (void)showError:(NSError *)error;
- (void)showError:(NSError *)error onCompletion:(YesBlock) yesBlock;
- (void)showPopUp:(NSString *)message;
- (void)showPopUp:(NSString *)message onCompletion:(YesBlock) yesBlock;
- (void)showPopUp:(NSString *)message onCompletion:(YesBlock) yesBlock onCancel:(CancelBlock)cancelBlock;

@end
