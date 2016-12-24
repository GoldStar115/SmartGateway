//
//  FeedbackVC.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "FeedbackCell.h"

@interface FeedbackVC : TableViewController
{
    NSMutableArray *groupedArray;
    NSMutableArray *headerArray;
    
    NSString *reason;
    NSMutableArray *feedbackArray;
}

@end
