//
//  MyProfileVC.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "InputCell.h"
//#import "PersonalHeaderView.h"

@interface MyProfileVC : TableViewController
{
    NSMutableArray *cellArray;
    bool imageChanged;
    
    IBOutlet UIView *headerView;
    IBOutlet UIImageView *profileImageView;
    
    UITextField *fullNameTextfield;
    UITextField *genderTextfield;
    UITextField *mobileNoTextfield;
    UITextField *emailTextfield;
}

@end
