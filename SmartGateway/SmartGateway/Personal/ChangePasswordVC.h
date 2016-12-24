//
//  ChangePasswordVC.h
//  SmartGateway
//
//  Created by Grace on 19/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "InputCell.h"

@interface ChangePasswordVC : TableViewController
{
    NSMutableArray *cellArray;
    
    UITextField *currentPasswordTextfield;
    UITextField *newPasswordTextfield;
    UITextField *confirmPasswordTextfield;
    
}

@end
