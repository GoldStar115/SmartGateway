//
//  SubmitFeedbackVC.h
//  SmartGateway
//
//  Created by Grace on 13/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//


#import "ViewController.h"

@interface SubmitFeedbackVC : ViewController
{
    IBOutlet UIButton *star1;
    IBOutlet UIButton *star2;
    IBOutlet UIButton *star3;
    IBOutlet UIButton *star4;
    IBOutlet UIButton *star5;

    IBOutlet UITextView *textview;
}

@property (nonatomic, strong) Feedback *feedback;
@property (nonatomic, strong) Maintenance *maintenance;

@end
