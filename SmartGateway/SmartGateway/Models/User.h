//
//  User.h
//  SmartGateway
//
//  Created by Grace on 18/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *default_condo;

@property (nonatomic, strong) NSString *image_url;

@end
