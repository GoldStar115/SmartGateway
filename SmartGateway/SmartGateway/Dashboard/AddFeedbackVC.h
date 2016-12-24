//
//  AddFeedbackVC.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "InputCell.h"

@interface AddFeedbackVC : TableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *cellArray;
    NSMutableArray *catArray;
    FeedbackCategory *selectedCat;
    
    UIImageView *imageView;
    UITextField *itemTextfield;
    UITextField *typeTextfield;
    UITextView *descriptionTextView;
    UITextField *apartmentTextfield;
    UITextField *blockUnitTextfield;
}

@end
