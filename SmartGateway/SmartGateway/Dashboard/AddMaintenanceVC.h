//
//  AddMaintenanceVC.h
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "InputCell.h"

@interface AddMaintenanceVC : TableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *cellArray;
    NSMutableArray *catArray;
    MaintenanceCategory *selectedCat;
    
    UIImageView *imageView;
    UITextField *itemTextfield;
    UITextField *typeTextfield;
    UITextView *descriptionTextView;
    UITextField *apartmentTextfield;
    UITextField *blockUnitTextfield;
}

@end
