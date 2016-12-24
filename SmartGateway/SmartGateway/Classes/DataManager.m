//
//  DataManager.m
//  SmartGateway
//
//  Created by Grace on 10/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "DataManager.h"

#define kUserDefaultToken @"SmartGateway-Token"

@implementation DataManager

static DataManager *sharedInstance = nil;

+ (DataManager *) sharedInstance
{
    if (sharedInstance == nil)
        sharedInstance = [[super allocWithZone:NULL] init];
    return  sharedInstance;
}

- (void) initialize
{
    self.serverDateFormatter = [[NSDateFormatter alloc] init];
    [self.serverDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    self.serverDateLongFormatter = [[NSDateFormatter alloc] init];
    [self.serverDateLongFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [self updateApiEngine];
}

- (void)updateApiEngine
{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:[Util getUDID] forKey:@"X-Client-Identifier"];
    if([self getToken] && [self getToken].length > 0)
        [headerFields setValue:[self getToken] forKey:@"Authorization"];
    
    self.apiEngine = [[APIEngine alloc] initWithHostName:@"api.lifeup.com.sg/v1" customHeaderFields:headerFields];
}

#pragma mark -
- (float)getTextHeightFromLabel:(UILabel *)label
{
    return [self getTextHeightFromLabel:label width:label.frame.size.width];
}

- (float)getTextHeightFromLabel:(UILabel *)label width:(float)width
{
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    return expectedLabelSize.height;
}

- (NSString *)getToken
{
    if(self.cUser)
        return self.cUser.token;
    
    NSString *token = [self getSavedToken];
    if(token && token.length > 0)
        return token;
    
    return nil;
}

- (void)login:(User *)user
{
    self.cUser = user;
    [self saveToken:self.cUser.token];
    [self updateApiEngine];
}

- (void)logout
{
    self.cUser = nil;
    [self removeToken];
    [self updateApiEngine];
}

- (NSString *) getSavedToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kUserDefaultToken];
}

- (void) saveToken:(NSString *)string
{
    //    NSLog(@"save user default account: %@", account);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:string forKey:kUserDefaultToken];
    [defaults synchronize];
}

- (void) removeToken
{
    //    NSLog(@"remove user default account");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kUserDefaultToken];
    [defaults synchronize];
}

- (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

- (UIImage*)imageWithImage:(UIImage *)image scaleToSizeKeepAspect:(CGSize)size
{
    float width =  size.width;
    float height = size.height;
    
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
