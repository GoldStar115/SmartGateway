//
//  BookingDetail.h
//  SmartGateway
//
//  Created by Grace on 30/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Booking.h"

@interface BookingDetail : NSObject

@property (nonatomic, strong) Booking *booking;
@property (nonatomic, strong) NSString *confirmed;
@property (nonatomic, strong) NSString *refunded;

@end
