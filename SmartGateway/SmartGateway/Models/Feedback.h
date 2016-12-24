//
//  Feedback.h
//  SmartGateway
//
//  Created by Grace on 5/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feedback : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *block;
@property (nonatomic, strong) NSString *condo;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *item;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *unit;

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *image;

@property (nonatomic, strong) NSArray *image_urls;

@end
