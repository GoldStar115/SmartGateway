//
//  DepositVC.h
//  SmartGateway
//
//  Created by Grace on 15/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "MaintenanceCell.h"
#import "InviteCell.h"
#import "DepositPopupVC.h"

@interface DepositVC : TableViewController //<PopupDelegate>
{
    NSMutableArray *groupedArray;
    NSMutableArray *headerArray;
    
    NSString *info;
}

@property (nonatomic, strong) Booking *booking;
@property (nonatomic, strong) NSMutableArray *session_ids;

@end
