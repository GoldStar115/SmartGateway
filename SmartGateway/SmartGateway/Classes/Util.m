//
//  Util.m
//  IOU
//
//  Created by Grace on 20/1/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSString*) getUDID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString*) getVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString*) getPlatform {
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        return @"iPad";
    return @"iPhone";
}

+ (NSString*) getPlatformVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*) getTimezone {
    return [NSString stringWithFormat:@"%d", (int)[[NSTimeZone systemTimeZone] secondsFromGMT]];
}

@end
