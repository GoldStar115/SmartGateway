//
//  RegisterVC.h
//  SmartGateway
//
//  Created by Grace on 10/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "InputCell.h"
#import "AgreeCell.h"

@interface RegisterVC : TableViewController
{
    NSMutableArray *cellArray;
    
    UITextField *phoneNumberTextfield;
    UITextField *passwordTextfield;
    UITextField *confirmPasswordTextfield;
    UITextField *nameTextfield;
    
    UIButton *agreeCheckbox;
}

@end
