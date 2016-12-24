//
//  CalendarCell.m
//  SmartGateway
//
//  Created by Grace on 14/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (void)setStatus:(NSString *)status
{
    UIColor *color = kBookingStatusNotAvailableColor;
    if([status isEqualToString:@"available"])
    {
        color = kBookingStatusAvailableColor;
    }
    else if([status isEqualToString:@"my_booking"])
    {
        color = kBookingStatusMyBookingColor;
    }
    else if([status isEqualToString:@"partially_blocked"])
    {
        color = kBookingStatusPartiallyBlockedColor;
    }
    else if([status isEqualToString:@"partially_booked"])
    {
        color = kBookingStatusPartiallyBookedColor;
    }
    else if([status isEqualToString:@"fully_booked"])
    {
        color = kBookingStatusFullyBookedColor;
    }
    else if([status isEqualToString:@"fully_blocked"])
    {
        color = kBookingStatusFullyBlockedColor;
    }
    self.statusView.backgroundColor = color;
    
    if(status == 0)
        self.dateLabel.textColor = color;
    else
        self.dateLabel.textColor = [UIColor blackColor];
}

@end
