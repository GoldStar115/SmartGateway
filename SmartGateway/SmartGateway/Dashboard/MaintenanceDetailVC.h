//
//  MaintenanceDetailVC.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "BookingCell.h"

@interface MaintenanceDetailVC : TableViewController
{
    NSMutableArray *groupedArray;
    NSMutableArray *headerArray;
    
    NSString *descriptionString;
    IBOutlet UIImageView *headerImageView;
}

@property (nonatomic, strong) Maintenance *maintenance;

@end
