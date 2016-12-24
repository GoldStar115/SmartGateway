//
//  Facility.h
//  SmartGateway
//
//  Created by Grace on 29/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Facility : NSObject

@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, strong) NSMutableArray *times;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *date;

@end
