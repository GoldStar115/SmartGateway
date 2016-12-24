//
//  SystemMessage.h
//  SmartGateway
//
//  Created by Grace on 1/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemMessage : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *create_date;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *subject;

@end
