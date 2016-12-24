//
//  Apartment.h
//  SmartGateway
//
//  Created by Grace on 27/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Condo.h"

@interface Apartment : NSObject

@property (nonatomic, strong) NSString *apartment_id;
@property (nonatomic, strong) Condo *condo;
@property (nonatomic, strong) NSString *apartment_default;
@property (nonatomic, strong) NSString *status;


@end
