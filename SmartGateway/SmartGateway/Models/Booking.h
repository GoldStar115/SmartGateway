//
//  Booking.h
//  SmartGateway
//
//  Created by Grace on 30/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Booking : NSObject

@property (nonatomic, strong) NSString *booking_id;
@property (nonatomic, strong) NSString *booking_time;
@property (nonatomic, strong) NSString *state;

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *deposit;
@property (nonatomic, strong) NSString *facility;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSString *payment_msg;
@property (nonatomic, strong) NSString *payment_amt;


@end
