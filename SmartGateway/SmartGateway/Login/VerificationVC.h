//
//  VerificationVC.h
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ViewController.h"

@interface VerificationVC : ViewController
{
    IBOutlet UILabel *phoneLabel;
    IBOutlet UITextField *codeTextfield;
}

@property (nonatomic, strong) NSString *registration_code;
@property (nonatomic, strong) NSString *phoneNumber;

@end
