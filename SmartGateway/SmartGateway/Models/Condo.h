//
//  Apartment.h
//  SmartGateway
//
//  Created by Grace on 20/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"

@interface Condo : NSObject

@property (nonatomic, strong) NSString *condo_id;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSMutableArray *buildings;
@property (nonatomic, strong) Building *building;

@end
