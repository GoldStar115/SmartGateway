//
//  InputCell.h
//  SmartGateway
//
//  Created by Grace on 10/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *textfield;
@property (retain, nonatomic) IBOutlet UITextField *textfield2;
@property (retain, nonatomic) IBOutlet UITextView *textview;

@property (retain, nonatomic) IBOutlet UIImageView *inputImageView;

@end
