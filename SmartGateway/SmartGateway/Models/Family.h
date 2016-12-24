//
//  Family.h
//  SmartGateway
//
//  Created by Grace on 11/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Family : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *relationship;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic) bool pending;

@end
