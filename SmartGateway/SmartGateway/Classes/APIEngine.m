//
//  APIEngine.m
//  SmartGateway
//
//  Created by Grace on 15/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "APIEngine.h"

@implementation APIEngine

#pragma mark Launch
- (MKNetworkOperation*) lat:(NSString *)lat
                        lng:(NSString *)lng
                    onCompletion:(AppLaunchBlock) completionBlock
                         onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:lat forKey:@"lat"];
    [params setValue:lng forKey:@"lng"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"launch/config"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         if([rawResponse objectForKey:@"Urls"])
         {
             Urls *urls = [self getUrlsFromDictionary:[rawResponse objectForKey:@"Urls"]];
             [dm setUrls:urls];
         }
         
         if([rawResponse objectForKey:@"Banners"])
         {
             NSMutableArray *banners = [[NSMutableArray alloc] init];
             for(NSDictionary *dic in [rawResponse objectForKey:@"Banners"])
             {
                 Banner *banner = [self getBannerFromDictionary:dic];
                 [banners addObject:banner];
             }
             [dm setBanners:banners];
         }
         
         if([rawResponse objectForKey:@"User"])
         {
             User *user = [self getUserFromDictionary:[rawResponse objectForKey:@"User"]];
             [dm login:user];
             completionBlock(message, user);
         }
         else
             completionBlock(message, nil);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark User
- (MKNetworkOperation*) login:(NSString *)username
                     password:(NSString *)password
                 onCompletion:(LoginBlock) completionBlock
                      onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [params setValue:password forKey:@"password"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/login"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         User *user = [self getUserFromDictionary:[rawResponse objectForKey:@"User"]];
         [dm login:user];
         completionBlock(message, user);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) registerUsername:(NSString *)username
                                  mobile:(NSString *)mobile
                                   email:(NSString *)email
                                    name:(NSString *)name
                                password:(NSString *)password
                            onCompletion:(RegisterBlock) completionBlock
                                 onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:email forKey:@"email"];
    [params setValue:name forKey:@"name"];
    [params setValue:password forKey:@"password"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/register"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSString *registration_code = [rawResponse objectForKey:@"registration_code"];
         completionBlock(message, registration_code);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) verify:(NSString *)registration_code
                    phone_code:(NSString *)phone_code
                      username:(NSString *)username
                      password:(NSString *)password
                  onCompletion:(VerifyBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:registration_code forKey:@"registration_code"];
    [params setValue:phone_code forKey:@"phone_code"];
    if(username && username.length > 0)
        [params setValue:username forKey:@"username"];
    if(password && password.length > 0)
        [params setValue:password forKey:@"password"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/verify"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         User *user = [self getUserFromDictionary:[rawResponse objectForKey:@"User"]];
         [dm login:user];
         completionBlock(message, user);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) forgot:(NSString *)username
                  onCompletion:(ForgotBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:username forKey:@"username"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/forgot"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSString *registration_code = [rawResponse objectForKey:@"registration_code"];
         completionBlock(message, registration_code);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) update:(NSString *)username
                          name:(NSString *)name
                        mobile:(NSString *)mobile
                         image:(NSString *)image
                        email:(NSString *)email
              current_password:(NSString *)current_password
                      password:(NSString *)password
                  onCompletion:(UpdateBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    if(username && username.length > 0)
        [params setValue:username forKey:@"username"];
    if(mobile && mobile.length > 0)
        [params setValue:mobile forKey:@"mobile"];
    if(image && mobile.length > 0)
        [params setValue:image forKey:@"image"];
    if(email && email.length > 0)
        [params setValue:email forKey:@"email"];
    if(name && name.length > 0)
        [params setValue:name forKey:@"name"];
    
    if(current_password && current_password.length > 0)
        [params setValue:current_password forKey:@"current_password"];
    if(password && password.length > 0)
        [params setValue:password forKey:@"password"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/update"]
                                              params:params
                                          httpMethod:@"PUT"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) logout:(LogoutBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"user/logout"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Apartment
- (MKNetworkOperation*) apartmentCondos:(NSString *)name
                           onCompletion:(ApartmentCondosBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:name forKey:@"name"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"apartment/condos"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *condos = [[NSMutableArray alloc] init];
         
         if([rawResponse objectForKey:@"Condos"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Condos"])
             {
                 Condo *condo = [self getCondoFromDictionary:dic];
                 [condos addObject:condo];
             }
         }
         completionBlock(message, condos);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) apartmentCondo:(NSString *)condo_id
                          onCompletion:(ApartmentCondoBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:condo_id forKey:@"condo_id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"apartment/condo"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         Condo *condo = [self getCondoFromDictionary:[rawResponse objectForKey:@"Condo"]];
         completionBlock(message, condo);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) apartmentAdd:(NSString *)unit_id
                            condo_id:(NSString *)condo_id
                        onCompletion:(ApartmentAddBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:unit_id forKey:@"unit_id"];
    [params setValue:condo_id forKey:@"condo_id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"apartment/add"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) apartmentListOnCompletion:(ApartmentListBlock) completionBlock
                                          onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"apartment/list"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *apartments = [[NSMutableArray alloc] init];
         
         if([rawResponse objectForKey:@"Apartments"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Apartments"])
             {
                 Apartment *apartment = [self getApartmentFromDictionary:dic];
                 [apartments addObject:apartment];
             }
         }
         completionBlock(message, apartments);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) apartmentSwitch:(NSString *)apartment_id
                           onCompletion:(ApartmentSwitchBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:apartment_id forKey:@"apartment_id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"apartment/switch"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) apartmentRemove:(NSString *)apartment_id
                           onCompletion:(ApartmentRemoveBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:apartment_id forKey:@"apartment_id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"apartment/remove"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Facility
- (MKNetworkOperation*) facilityOnCompletion:(FacilityBlock) completionBlock
                                     onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"facility/type"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *types = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"Type"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Type"])
             {
                 FacilityType *type = [self getFacilityTypeFromDictionary:dic];
                 [types addObject:type];
             }
         }
         completionBlock(message, types);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) facilityType:(NSString *)facilitytype_id
                        onCompletion:(FacilityTypeBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"facilities/%@", facilitytype_id]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *facilities = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"Facility"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Facility"])
             {
                 Facility *facility = [self getFacilityFromDictionary:dic];
                 [facilities addObject:facility];
             }
         }
         completionBlock(message, facilities);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) facilitySession:(NSString *)facility_id
                                   date:(NSString *)date
                           onCompletion:(FacilitySessionBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"facility/session/%@/%@", facility_id, date]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         Facility *facility = [self getFacilityFromDictionary:[rawResponse objectForKey:@"Facility"]];
         completionBlock(message, facility);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Booking
- (MKNetworkOperation*) booking:(NSString *)session_ids
                   onCompletion:(BookingBlock) completionBlock
                        onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:session_ids forKey:@"session_ids"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"booking/book"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         Booking *booking = [self getBookingFromDictionary:[rawResponse objectForKey:@"Booking"]];
         completionBlock(message, booking);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) bookingConfirm:(NSString *)session_ids
                          payment_type:(NSString *)payment_type
                          onCompletion:(BookingConfirmBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:session_ids forKey:@"session_ids"];
    [params setValue:payment_type forKey:@"payment_type"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"booking/confirm/"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) bookingListOnCompletion:(BookingListBlock) completionBlock
                                        onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"booking/list"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *bookings = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"Bookings"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Bookings"])
             {
                 Booking *booking = [self getBookingFromDictionary:dic];
                 [bookings addObject:booking];
             }
         }
         completionBlock(message, bookings);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) bookingDetail:(NSString *)booking_id
                      onCompletion:(BookingDetailBlock) completionBlock
                           onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:booking_id forKey:@"booking_id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"booking/detail"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         BookingDetail *detail = [self getBookingDetailFromDictionary:rawResponse];
         completionBlock(message, detail);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) bookingCancel:(NSString *)booking_id
                         onCompletion:(BookingCancelBlock) completionBlock
                              onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:booking_id forKey:@"booking_id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"booking/cancel"]
                                              params:params
                                          httpMethod:@"PUT"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Maintenance
- (MKNetworkOperation*) maintenanceListOnCompletion:(MaintenanceListBlock) completionBlock
                                            onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"maintenance/list"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         
         NSMutableArray *maintenanceList = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"maintenance_list"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"maintenance_list"])
             {
                 Maintenance *maintenance = [self getMaintenanceFromDictionary:dic];
                 [maintenanceList addObject:maintenance];
             }
         }
         completionBlock(message, maintenanceList);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) maintenanceCategoryOnCompletion:(MaintenanceCategoryBlock) completionBlock
                                            onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"maintenance/category"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *cats = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"Maintenance_category"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Maintenance_category"])
             {
                 MaintenanceCategory *cat = [self getMaintenanceCategoryFromDictionary:dic];
                 [cats addObject:cat];
             }
         }
         completionBlock(message, cats);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) maintenanceRegister:(NSString *)item
                                category_id:(NSString *)category_id
                                description:(NSString *)description
                                      image:(NSString *)image
                               onCompletion:(MaintenanceRegisterBlock) completionBlock
                                    onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:item forKey:@"item"];
    [params setValue:category_id forKey:@"category_id"];
    [params setValue:description forKey:@"description"];
    [params setValue:image forKey:@"image"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"maintenance/register"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) maintenanceRate:(NSString *)maintenance_id
                                   rate:(NSString *)rate
                                comment:(NSString *)comment
                           onCompletion:(MaintenanceRateBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:maintenance_id forKey:@"id"];
    [params setValue:rate forKey:@"rate"];
    [params setValue:comment forKey:@"comment"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"maintenance/rate"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) maintenanceDetail:(NSString *)maintenance_id
                             onCompletion:(MaintenanceDetailBlock) completionBlock
                                  onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:maintenance_id forKey:@"id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"maintenance/detail"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         Maintenance *maintenance = [self getMaintenanceFromDictionary:[rawResponse objectForKey:@"maintenance"]];
         completionBlock(message, maintenance);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Feedback
- (MKNetworkOperation*) feedbackListOnCompletion:(FeedbackListBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"feedback/list"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *feedbackList = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"feedback_list"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"feedback_list"])
             {
                 Feedback *feedback = [self getFeedbackFromDictionary:dic];
                 [feedbackList addObject:feedback];
             }
         }
         completionBlock(message, feedbackList);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) feedbackCategoryOnCompletion:(FeedbackCategoryBlock) completionBlock
                                             onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"feedback/category"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *cats = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"Feedback_category"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Feedback_category"])
             {
                 FeedbackCategory *cat = [self getFeedbackCategoryFromDictionary:dic];
                 [cats addObject:cat];
             }
         }
         completionBlock(message, cats);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) feedbackRegister:(NSString *)item
                             category_id:(NSString *)category_id
                             description:(NSString *)description
                                   image:(NSString *)image
                            onCompletion:(FeedbackRegisterBlock) completionBlock
                                 onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:item forKey:@"item"];
    [params setValue:category_id forKey:@"category_id"];
    [params setValue:description forKey:@"description"];
    [params setValue:image forKey:@"image"];

    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"feedback/register"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) feedbackDetail:(NSString *)feedback_id
                          onCompletion:(FeedbackDetailBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:feedback_id forKey:@"id"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"feedback/detail"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         Feedback *feedback = [self getFeedbackFromDictionary:[rawResponse objectForKey:@"feedback"]];
         completionBlock(message, feedback);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) feedbackRate:(NSString *)feedback_id
                                rate:(NSString *)rate
                             comment:(NSString *)comment
                        onCompletion:(FeedbackRateBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:feedback_id forKey:@"id"];
    [params setValue:rate forKey:@"rate"];
    [params setValue:comment forKey:@"comment"];

    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"feedback/rate"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Announcement
- (MKNetworkOperation*) announcementOnCompletion:(AnnouncementListBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"announcement/list"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         Announcement *announcement = [self getAnnouncementFromDictionary:[rawResponse objectForKey:@"Announcement"]];
         completionBlock(message, announcement);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Family
- (MKNetworkOperation*) familyListOnCompletion:(FamilyBlock) completionBlock
                                       onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"family/list"]
                                              params:params
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         NSMutableArray *familyList = [[NSMutableArray alloc] init];
         if([rawResponse objectForKey:@"Family"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Family"])
             {
                 Family *family = [self getFamilyFromDictionary:dic];
                 family.pending = NO;
                 [familyList addObject:family];
             }
         }
         
         if([rawResponse objectForKey:@"Pending_Family"])
         {
             for(NSDictionary *dic in [rawResponse objectForKey:@"Pending_Family"])
             {
                 Family *family = [self getFamilyFromDictionary:dic];
                 family.pending = YES;
                 [familyList addObject:family];
             }
         }
         completionBlock(message, familyList);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) familyRemove:(NSString *)family_id
                             pending:(bool)pending
                        onCompletion:(FamilyRemoveBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    if(pending)
        [params setValue:family_id forKey:@"pending_family_id"];
    else
        [params setValue:family_id forKey:@"family_id"];

    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"family/remove"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) familyRegister:(NSString *)mobile
                          relationship:(NSString *)relationship
                          onCompletion:(FamilyRegisterBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:relationship forKey:@"relationship"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"family/invite"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) familyActivate:(NSString *)phone_code
                          onCompletion:(FamilyActivateBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:phone_code forKey:@"phone_code"];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"family/activate"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark Wallet
- (MKNetworkOperation*) walletOnCompletion:(WalletBlock) completionBlock
                                       onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"account/wallet/balance"]
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         
         Wallet *wallet = [self getWalletFromDictionary:[rawResponse objectForKey:@"wallet"]];
         completionBlock(message, wallet);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) walletPayment:(NSString *)booking_id
                        onCompletion:(WalletPaymentBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock {
    
    NSMutableDictionary *params  = [[NSMutableDictionary alloc] init];
    [params setValue:booking_id forKey:@"booking_id"];
    
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"account/booking/payment"]
                                              params:params
                                          httpMethod:@"PUT"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSString* message = [self handleAlert:completedOperation];
         
         NSArray *jsonResponse = [completedOperation responseJSON];
         NSDictionary *rawResponse = (NSDictionary *) jsonResponse;
         NSLog(@"raw: %@", rawResponse);
         completionBlock(message, YES);
     }errorHandler:^(MKNetworkOperation *completedOperation, NSError* error) {
         error = [self handleError:error networkOperation:completedOperation];
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

#pragma mark -
- (NSString *)handleAlert:(MKNetworkOperation *)completedOperation
{
    NSArray *jsonResponse = [completedOperation responseJSON];
    NSDictionary *errorResponse = (NSDictionary *) jsonResponse;
    NSString *errorMessage = [errorResponse objectForKey:@"detail"];
    if(errorMessage)
    {
    
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:errorMessage
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
//                                                  otherButtonTitles:nil];
//        [alertview show];
        return errorMessage;
    }
    
    NSString *alertMessage = [errorResponse objectForKey:@"alert"];
    if(alertMessage)
        return alertMessage;
        
    return nil;
}

- (NSError *)handleError:(NSError *)error networkOperation:(MKNetworkOperation *)completedOperation
{
//    NSLog(@"error code: %d", (int)error.code);
    
    NSArray *jsonResponse = [completedOperation responseJSON];
    NSDictionary *errorResponse = (NSDictionary *) jsonResponse;
    NSString *errorMessage = [errorResponse objectForKey:@"detail"];
    if(!errorMessage && error.code == 200)
        return nil;
    
    if(error.code == 401)
    {
        //invalid token
        [dm logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
        return nil;
    }

    if(errorMessage)
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:errorMessage forKey:NSLocalizedDescriptionKey];

        error = [NSError errorWithDomain:error.domain code:error.code userInfo:errorDetail];
    }
    
    return error;
}

- (NSString *)getString:(NSString *)string
{
    if(!string)
        return @"";
    if([string isEqual: [NSNull null]])
        return @"";
    return [NSString stringWithFormat:@"%@", string];
}

- (User *)getUserFromDictionary:(NSDictionary *)feed
{
    User *user          = [[User alloc] init];
    user.username       = [self getString:[feed objectForKey:@"username"]];
    user.email          = [self getString:[feed objectForKey:@"email"]];
    user.image          = [self getString:[feed objectForKey:@"image"]];
    user.login          = [self getString:[feed objectForKey:@"login"]];
    user.mobile         = [self getString:[feed objectForKey:@"mobile"]];
    user.name           = [self getString:[feed objectForKey:@"name"]];
    user.token          = [self getString:[feed objectForKey:@"token"]];
    user.default_condo  = [self getString:[feed objectForKey:@"default_condo"]];
    user.image_url      = [self getString:[feed objectForKey:@"image_url"]];
    
    if(!user.username || user.username.length == 0)
        user.username = user.mobile;
    if(!user.token || user.token.length == 0)
        user.token = [dm getSavedToken];
    return user;
}

- (Apartment *)getApartmentFromDictionary:(NSDictionary *)feed
{
    Apartment *apartment        = [[Apartment alloc] init];
    apartment.apartment_id      = [self getString:[feed objectForKey:@"apartment_id"]];
    apartment.apartment_default = [self getString:[feed objectForKey:@"default"]];
    apartment.status            = [self getString:[feed objectForKey:@"status"]];
    apartment.condo             = [self getCondoFromDictionary:[feed objectForKey:@"condo"]];
    return apartment;
}

- (Condo *)getCondoFromDictionary:(NSDictionary *)feed
{
    Condo *condo        = [[Condo alloc] init];
    condo.condo_id      = [self getString:[feed objectForKey:@"condo_id"]];
    condo.name          = [self getString:[feed objectForKey:@"name"]];
    
    if([feed objectForKey:@"building"])
        condo.building  = [self getBuildingFromDictionary:[feed objectForKey:@"building"]];
//    NSLog(@"name: %@", condo.name);
    
    if([feed objectForKey:@"buildings"])
    {
        NSMutableArray *buildings = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [feed objectForKey:@"buildings"])
        {
            Building *building = [self getBuildingFromDictionary:dic];
//            NSLog(@"add building: %@", building.block);
            [buildings addObject:building];
        }
        condo.buildings    = buildings;
//        NSLog(@"total building: %ld", buildings.count);
    }
    return condo;
}

- (Building *)getBuildingFromDictionary:(NSDictionary *)feed
{
    Building *building      = [[Building alloc] init];
    building.building_id    = [self getString:[feed objectForKey:@"building_id"]];
    building.block          = [self getString:[feed objectForKey:@"block"]];
    
    if([feed objectForKey:@"level"])
        building.level      = [self getLevelFromDictionary:[feed objectForKey:@"level"]];
    
    if([feed objectForKey:@"levels"])
    {
        NSMutableArray *levels = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [feed objectForKey:@"levels"])
        {
            Level *level = [self getLevelFromDictionary:dic];
            [levels addObject:level];
        }
        building.levels    = levels;
//        NSLog(@"total building: %ld", levels.count);
    }
    return building;
}

- (Level *)getLevelFromDictionary:(NSDictionary *)feed
{
    Level *level    = [[Level alloc] init];
    level.level     = [self getString:[feed objectForKey:@"level"]];
    
    if([feed objectForKey:@"unit"])
        level.unit  = [self getUnitFromDictionary:[feed objectForKey:@"unit"]];

    if([feed objectForKey:@"units"])
    {
        NSMutableArray *units = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [feed objectForKey:@"units"])
        {
            Unit *unit = [self getUnitFromDictionary:dic];
            [units addObject:unit];
        }
        level.units    = units;
//        NSLog(@"total unit: %ld", units.count);
    }
    return level;
}

- (Unit *)getUnitFromDictionary:(NSDictionary *)feed
{
    Unit *unit      = [[Unit alloc] init];
    unit.unit_id    = [self getString:[feed objectForKey:@"unit_id"]];
    unit.unit_no    = [self getString:[feed objectForKey:@"unit_no"]];
    return unit;
}

- (Urls *)getUrlsFromDictionary:(NSDictionary *)feed
{
    Urls *urls          = [[Urls alloc] init];
    urls.about_url      = [self getString:[feed objectForKey:@"about_url"]];
    urls.agreement_url  = [self getString:[feed objectForKey:@"agreement_url"]];
    urls.privacy_url    = [self getString:[feed objectForKey:@"privacy_url"]];
    urls.terms_url      = [self getString:[feed objectForKey:@"terms_url"]];
    urls.property_url   = [self getString:[feed objectForKey:@"property_url"]];
    return urls;
}

- (FacilityType *)getFacilityTypeFromDictionary:(NSDictionary *)feed
{
    FacilityType *type  = [[FacilityType alloc] init];
    type.type_id        = [self getString:[feed objectForKey:@"id"]];
    type.type           = [self getString:[feed objectForKey:@"type"]];
    return type;
}

- (Facility *)getFacilityFromDictionary:(NSDictionary *)feed
{
    Facility *facility      = [[Facility alloc] init];
    
    if([feed objectForKey:@"dates"])
    {
        NSMutableArray *dates = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [feed objectForKey:@"dates"])
        {
            FacilityDate *date = [self getFacilityDateFromDictionary:dic];
            [dates addObject:date];
        }
        facility.dates      = dates;
    }
    
    if([feed objectForKey:@"time"])
    {
        NSMutableArray *times = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [feed objectForKey:@"time"])
        {
            FacilityTime *date = [self getFacilityTimeFromDictionary:dic];
            [times addObject:date];
        }
        facility.times      = times;
    }
    
    facility.fid            = [self getString:[feed objectForKey:@"fid"]];
    facility.image_url      = [self getString:[feed objectForKey:@"image_url"]];
    facility.name           = [self getString:[feed objectForKey:@"name"]];
    return facility;
}

- (FacilityDate *)getFacilityDateFromDictionary:(NSDictionary *)feed
{
    FacilityDate *date  = [[FacilityDate alloc] init];
    date.date_id        = [self getString:[feed objectForKey:@"id"]];
    date.bookdate       = [self getString:[feed objectForKey:@"bookdate"]];
    date.state          = [self getString:[feed objectForKey:@"state"]];
    return date;
}

- (FacilityTime *)getFacilityTimeFromDictionary:(NSDictionary *)feed
{
    FacilityTime *time  = [[FacilityTime alloc] init];
    time.end            = [self getString:[feed objectForKey:@"end"]];
    time.peak           = [self getString:[feed objectForKey:@"peak"]];
    time.session_id     = [self getString:[feed objectForKey:@"session_id"]];
    time.start          = [self getString:[feed objectForKey:@"start"]];
    time.status         = [self getString:[feed objectForKey:@"status"]];
    return time;
}

- (Booking *)getBookingFromDictionary:(NSDictionary *)feed
{
    Booking *booking        = [[Booking alloc] init];
    booking.date            = [self getString:[feed objectForKey:@"date"]];
    booking.deposit         = [self getString:[feed objectForKey:@"deposit"]];
    booking.facility        = [self getString:[feed objectForKey:@"facility"]];
    booking.fee             = [self getString:[feed objectForKey:@"fee"]];
    booking.time            = [self getString:[feed objectForKey:@"time"]];
    
    booking.booking_id      = [self getString:[feed objectForKey:@"booking_id"]];
    booking.booking_time    = [self getString:[feed objectForKey:@"booking_time"]];
    booking.state           = [self getString:[feed objectForKey:@"state"]];

    booking.payment_msg     = [self getString:[feed objectForKey:@"payment_msg"]];
    booking.payment_amt     = [self getString:[feed objectForKey:@"payment_amt"]];
    return booking;
}

- (BookingDetail *)getBookingDetailFromDictionary:(NSDictionary *)feed
{
    BookingDetail *detail   = [[BookingDetail alloc] init];
    if([feed objectForKey:@"Booking"])
        detail.booking      = [self getBookingFromDictionary:[feed objectForKey:@"Booking"]];

    detail.confirmed        = [self getString:[feed objectForKey:@"confirmed"]];
    detail.refunded         = [self getString:[feed objectForKey:@"refunded"]];
    return detail;
}

- (Announcement *)getAnnouncementFromDictionary:(NSDictionary *)feed
{
    Announcement *announcement      = [[Announcement alloc] init];
    
    if([feed objectForKey:@"condo"])
    {
        NSMutableArray *condos = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [feed objectForKey:@"condo"])
        {
            SystemMessage *date = [self getSystemMessageFromDictionary:dic];
            [condos addObject:date];
        }
        announcement.condo      = condos;
    }
    
    if([feed objectForKey:@"system"])
    {
        NSMutableArray *systems = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [feed objectForKey:@"system"])
        {
            SystemMessage *date = [self getSystemMessageFromDictionary:dic];
            [systems addObject:date];
        }
        announcement.system      = systems;
    }
    
    return announcement;
}

- (SystemMessage *)getSystemMessageFromDictionary:(NSDictionary *)feed
{
    SystemMessage *sMessage     = [[SystemMessage alloc] init];
    sMessage.content            = [self getString:[feed objectForKey:@"content"]];
    sMessage.create_date        = [self getString:[feed objectForKey:@"create_date"]];
    sMessage.id                 = [self getString:[feed objectForKey:@"id"]];
    sMessage.status             = [self getString:[feed objectForKey:@"status"]];
    sMessage.subject            = [self getString:[feed objectForKey:@"subject"]];
    return sMessage;
}

- (MaintenanceCategory *)getMaintenanceCategoryFromDictionary:(NSDictionary *)feed
{
    MaintenanceCategory *mCategory  = [[MaintenanceCategory alloc] init];
    mCategory.id                    = [self getString:[feed objectForKey:@"id"]];
    mCategory.name                  = [self getString:[feed objectForKey:@"name"]];
    return mCategory;
}

- (FeedbackCategory *)getFeedbackCategoryFromDictionary:(NSDictionary *)feed
{
    FeedbackCategory *fCategory     = [[FeedbackCategory alloc] init];
    fCategory.id                    = [self getString:[feed objectForKey:@"id"]];
    fCategory.name                  = [self getString:[feed objectForKey:@"name"]];
    return fCategory;
}

- (Maintenance *)getMaintenanceFromDictionary:(NSDictionary *)feed
{
    Maintenance *maintenance    = [[Maintenance alloc] init];
    maintenance.id              = [self getString:[feed objectForKey:@"id"]];
    maintenance.block           = [self getString:[feed objectForKey:@"block"]];
    maintenance.condo           = [self getString:[feed objectForKey:@"condo"]];
    maintenance.date            = [self getString:[feed objectForKey:@"date"]];
    maintenance.item            = [self getString:[feed objectForKey:@"item"]];
    maintenance.status          = [self getString:[feed objectForKey:@"status"]];
    maintenance.unit            = [self getString:[feed objectForKey:@"unit"]];
    
    maintenance.category        = [self getString:[feed objectForKey:@"category"]];
    maintenance.desc            = [self getString:[feed objectForKey:@"description"]];
    maintenance.image           = [self getString:[feed objectForKey:@"image"]];
    
    maintenance.image_urls      = [feed objectForKey:@"image_urls"];
    
    return maintenance;
}

- (Feedback *)getFeedbackFromDictionary:(NSDictionary *)feed
{
    Feedback *feedback      = [[Feedback alloc] init];
    feedback.id             = [self getString:[feed objectForKey:@"id"]];
    feedback.block          = [self getString:[feed objectForKey:@"block"]];
    feedback.condo          = [self getString:[feed objectForKey:@"condo"]];
    feedback.date           = [self getString:[feed objectForKey:@"date"]];
    feedback.item           = [self getString:[feed objectForKey:@"item"]];
    feedback.status         = [self getString:[feed objectForKey:@"status"]];
    feedback.unit           = [self getString:[feed objectForKey:@"unit"]];
    
    feedback.category       = [self getString:[feed objectForKey:@"category"]];
    feedback.desc           = [self getString:[feed objectForKey:@"description"]];
    feedback.image          = [self getString:[feed objectForKey:@"image"]];
    
    feedback.image_urls     = [feed objectForKey:@"image_urls"];
    
    return feedback;
}

- (Banner *)getBannerFromDictionary:(NSDictionary *)feed
{
    Banner *banner  = [[Banner alloc] init];
    banner.id       = [self getString:[feed objectForKey:@"id"]];
    banner.image    = [self getString:[feed objectForKey:@"image"]];
    banner.url      = [self getString:[feed objectForKey:@"url"]];
    return banner;
}


- (Family *)getFamilyFromDictionary:(NSDictionary *)feed
{
    Family *family          = [[Family alloc] init];
    family.name             = [self getString:[feed objectForKey:@"name"]];
    family.relationship     = [self getString:[feed objectForKey:@"relationship"]];
    family.user_id          = [self getString:[feed objectForKey:@"user_id"]];
    return family;
}

- (Wallet *)getWalletFromDictionary:(NSDictionary *)feed
{
    Wallet *wallet          = [[Wallet alloc] init];
    wallet.balance          = [self getString:[feed objectForKey:@"balance"]];
    wallet.currency         = [self getString:[feed objectForKey:@"currency"]];
    wallet.history_url      = [self getString:[feed objectForKey:@"history_url"]];
    wallet.purchase_url     = [self getString:[feed objectForKey:@"purchase_url"]];
    wallet.topup_url        = [self getString:[feed objectForKey:@"topup_url"]];
    wallet.transfer_url     = [self getString:[feed objectForKey:@"transfer_url"]];
    return wallet;
}

@end
