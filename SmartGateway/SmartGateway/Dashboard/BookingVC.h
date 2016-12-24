//
//  BookingVC.h
//  SmartGateway
//
//  Created by Grace on 15/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "BookingCell.h"

@interface BookingVC : TableViewController
{
    NSMutableArray *cellArray;
}

@property (nonatomic, strong) Facility *facility;
@property (nonatomic, strong) FacilityDate *facilityDate;

@end
