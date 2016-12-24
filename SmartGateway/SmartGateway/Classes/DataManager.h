//
//  DataManager.h
//  SmartGateway
//
//  Created by Grace on 10/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIEngine.h"
#import "Util.h"

#define dm ([DataManager sharedInstance])

#define kBookingStatusNotAvailableColor [UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1.0]
#define kBookingStatusAvailableColor [UIColor colorWithRed:145/255.0 green:218/255.0 blue:155/255.0 alpha:1.0]
#define kBookingStatusMyBookingColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1.0]
#define kBookingStatusPartiallyBlockedColor [UIColor colorWithRed:255/255.0 green:0/255.0 blue:255/255.0 alpha:1.0]
#define kBookingStatusPartiallyBookedColor [UIColor colorWithRed:255/255.0 green:242/255.0 blue:0/255.0 alpha:1.0]
#define kBookingStatusFullyBookedColor [UIColor colorWithRed:237/255.0 green:28/255.0 blue:36/255.0 alpha:1.0]
#define kBookingStatusFullyBlockedColor [UIColor colorWithRed:158/255.0 green:11/255.0 blue:15/255.0 alpha:1.0]

#define kImagePickerTypeCamera @"Take Photo"
#define kImagePickerTypePhotoLibrary @"Photo Library"

#define kImageSize 500.0f;

@interface DataManager : NSObject

@property (nonatomic, retain) APIEngine *apiEngine;
@property (nonatomic, retain) User *cUser;
@property (nonatomic, retain) Urls *urls;
@property (nonatomic, retain) NSMutableArray *banners;
@property (nonatomic, retain) NSDateFormatter *serverDateFormatter;
@property (nonatomic, retain) NSDateFormatter *serverDateLongFormatter;

+ (id) sharedInstance;
- (void) initialize;

- (float)getTextHeightFromLabel:(UILabel *)label;
- (float)getTextHeightFromLabel:(UILabel *)label width:(float)width;

- (void)login:(User *)user;
- (void)logout;

- (NSString *)encodeToBase64String:(UIImage *)image;
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

- (NSString *) getSavedToken;
- (UIImage*)imageWithImage:(UIImage *)image scaleToSizeKeepAspect:(CGSize)size;

@end
