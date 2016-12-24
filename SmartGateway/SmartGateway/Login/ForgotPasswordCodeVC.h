//
//  ForgotPasswordCodeVC.h
//  SmartGateway
//
//  Created by Grace on 19/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ViewController.h"

@interface ForgotPasswordCodeVC : ViewController
{
    IBOutlet UITextField *codeTextfield;
    IBOutlet UITextField *newPasswordTextfield;
    IBOutlet UITextField *confirmPasswordTextfield;
}

@property (nonatomic, strong) NSString *registration_code;
@property (nonatomic, strong) NSString *username;

@end
