//
//  BookingDetailVC.h
//  SmartGateway
//
//  Created by Grace on 9/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "BookingCell.h"

@interface BookingDetailVC : TableViewController
{
    NSMutableArray *groupedArray;
    NSMutableArray *headerArray;
    
    NSString *reason;
    
    BookingDetail *bdetail;
}

@property(nonatomic,strong) Booking *booking;

@end
