//
//  Level.h
//  SmartGateway
//
//  Created by Grace on 20/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"

@interface Level : NSObject

@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSMutableArray *units;
@property (nonatomic, strong) Unit *unit;

@end
