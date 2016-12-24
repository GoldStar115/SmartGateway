//
//  Building.h
//  SmartGateway
//
//  Created by Grace on 20/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface Building : NSObject

@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) NSString *block;
@property (nonatomic, strong) NSMutableArray *levels;
@property (nonatomic, strong) Level *level;

@end
