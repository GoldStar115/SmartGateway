//
//  APIEngine.h
//  SmartGateway
//
//  Created by Grace on 15/6/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "User.h"
#import "Condo.h"
#import "Building.h"
#import "Level.h"
#import "Unit.h"
#import "Apartment.h"
#import "Urls.h"
#import "Facility.h"
#import "FacilityType.h"
#import "FacilityDate.h"
#import "FacilityTime.h"
#import "Booking.h"
#import "BookingDetail.h"
#import "Announcement.h"
#import "SystemMessage.h"
#import "MaintenanceCategory.h"
#import "FeedbackCategory.h"
#import "Maintenance.h"
#import "Feedback.h"
#import "Banner.h"
#import "Family.h"
#import "Wallet.h"

@interface APIEngine : MKNetworkEngine

#pragma mark Launch
typedef void (^AppLaunchBlock) (NSString *message, User *result);
- (MKNetworkOperation*) lat:(NSString *)lat
                        lng:(NSString *)lng
               onCompletion:(AppLaunchBlock) completionBlock
                    onError:(MKNKErrorBlock) errorBlock;

#pragma mark User
typedef void (^LoginBlock) (NSString *message, User *result);
- (MKNetworkOperation*) login:(NSString *)username
                     password:(NSString *)password
                 onCompletion:(LoginBlock) completionBlock
                      onError:(MKNKErrorBlock) errorBlock;

typedef void (^RegisterBlock) (NSString *message, NSString *result);
- (MKNetworkOperation*) registerUsername:(NSString *)username
                                  mobile:(NSString *)mobile
                                   email:(NSString *)email
                                    name:(NSString *)name
                                password:(NSString *)password
                            onCompletion:(RegisterBlock) completionBlock
                                 onError:(MKNKErrorBlock) errorBlock;

typedef void (^VerifyBlock) (NSString *message, User *result);
- (MKNetworkOperation*) verify:(NSString *)registration_code
                    phone_code:(NSString *)phone_code
                      username:(NSString *)username
                      password:(NSString *)password
                  onCompletion:(VerifyBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock;

typedef void (^ForgotBlock) (NSString *message, NSString *result);
- (MKNetworkOperation*) forgot:(NSString *)username
                  onCompletion:(ForgotBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock;

typedef void (^UpdateBlock) (NSString *message, bool result);
- (MKNetworkOperation*) update:(NSString *)username
                          name:(NSString *)name
                        mobile:(NSString *)mobile
                         image:(NSString *)image
                         email:(NSString *)email
              current_password:(NSString *)current_password
                      password:(NSString *)password
                  onCompletion:(UpdateBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock;

typedef void (^LogoutBlock) (NSString *message, bool result);
- (MKNetworkOperation*) logout:(LogoutBlock) completionBlock
                       onError:(MKNKErrorBlock) errorBlock;

#pragma mark Apartment
typedef void (^ApartmentCondosBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) apartmentCondos:(NSString *)name
                           onCompletion:(ApartmentCondosBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock;

typedef void (^ApartmentCondoBlock) (NSString *message, Condo *result);
- (MKNetworkOperation*) apartmentCondo:(NSString *)condo_id
                          onCompletion:(ApartmentCondoBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock;

typedef void (^ApartmentAddBlock) (NSString *message, bool result);
- (MKNetworkOperation*) apartmentAdd:(NSString *)unit_id
                            condo_id:(NSString *)condo_id
                        onCompletion:(ApartmentAddBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock;

typedef void (^ApartmentListBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) apartmentListOnCompletion:(ApartmentListBlock) completionBlock
                                          onError:(MKNKErrorBlock) errorBlock;

typedef void (^ApartmentSwitchBlock) (NSString *message, bool result);
- (MKNetworkOperation*) apartmentSwitch:(NSString *)apartment_id
                           onCompletion:(ApartmentSwitchBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock;

typedef void (^ApartmentRemoveBlock) (NSString *message, bool result);
- (MKNetworkOperation*) apartmentRemove:(NSString *)apartment_id
                           onCompletion:(ApartmentRemoveBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock;

#pragma mark Facility
typedef void (^FacilityBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) facilityOnCompletion:(FacilityBlock) completionBlock
                                     onError:(MKNKErrorBlock) errorBlock;

typedef void (^FacilityTypeBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) facilityType:(NSString *)facilitytype_id
                        onCompletion:(FacilityTypeBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock;

typedef void (^FacilitySessionBlock) (NSString *message, Facility *result);
- (MKNetworkOperation*) facilitySession:(NSString *)facility_id
                                   date:(NSString *)date
                           onCompletion:(FacilitySessionBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock;

#pragma mark Booking
typedef void (^BookingBlock) (NSString *message, Booking *result);
- (MKNetworkOperation*) booking:(NSString *)session_ids
                   onCompletion:(BookingBlock) completionBlock
                        onError:(MKNKErrorBlock) errorBlock;

typedef void (^BookingConfirmBlock) (NSString *message, bool result);
- (MKNetworkOperation*) bookingConfirm:(NSString *)session_ids
                          payment_type:(NSString *)payment_type
                          onCompletion:(BookingConfirmBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock;

typedef void (^BookingListBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) bookingListOnCompletion:(BookingListBlock) completionBlock
                                        onError:(MKNKErrorBlock) errorBlock;

typedef void (^BookingDetailBlock) (NSString *message, BookingDetail *result);
- (MKNetworkOperation*) bookingDetail:(NSString *)booking_id
                         onCompletion:(BookingDetailBlock) completionBlock
                              onError:(MKNKErrorBlock) errorBlock;

typedef void (^BookingCancelBlock) (NSString *message, bool result);
- (MKNetworkOperation*) bookingCancel:(NSString *)booking_id
                         onCompletion:(BookingCancelBlock) completionBlock
                              onError:(MKNKErrorBlock) errorBlock;

#pragma mark Maintenance
typedef void (^MaintenanceListBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) maintenanceListOnCompletion:(MaintenanceListBlock) completionBlock
                                            onError:(MKNKErrorBlock) errorBlock;

typedef void (^MaintenanceCategoryBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) maintenanceCategoryOnCompletion:(MaintenanceCategoryBlock) completionBlock
                                                onError:(MKNKErrorBlock) errorBlock;

typedef void (^MaintenanceRegisterBlock) (NSString *message, bool result);
- (MKNetworkOperation*) maintenanceRegister:(NSString *)item
                                category_id:(NSString *)category_id
                                description:(NSString *)description
                                      image:(NSString *)image
                               onCompletion:(MaintenanceRegisterBlock) completionBlock
                                    onError:(MKNKErrorBlock) errorBlock;

typedef void (^MaintenanceRateBlock) (NSString *message, bool result);
- (MKNetworkOperation*) maintenanceRate:(NSString *)maintenance_id
                                   rate:(NSString *)rate
                                comment:(NSString *)comment
                           onCompletion:(MaintenanceRateBlock) completionBlock
                                onError:(MKNKErrorBlock) errorBlock;

typedef void (^MaintenanceDetailBlock) (NSString *message, Maintenance *result);
- (MKNetworkOperation*) maintenanceDetail:(NSString *)maintenance_id
                             onCompletion:(MaintenanceDetailBlock) completionBlock
                                  onError:(MKNKErrorBlock) errorBlock;

#pragma mark Feedback
typedef void (^FeedbackListBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) feedbackListOnCompletion:(FeedbackListBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock;

typedef void (^FeedbackCategoryBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) feedbackCategoryOnCompletion:(FeedbackCategoryBlock) completionBlock
                                             onError:(MKNKErrorBlock) errorBlock;

typedef void (^FeedbackRegisterBlock) (NSString *message, bool result);
- (MKNetworkOperation*) feedbackRegister:(NSString *)item
                             category_id:(NSString *)category_id
                             description:(NSString *)description
                                   image:(NSString *)image
                            onCompletion:(FeedbackRegisterBlock) completionBlock
                                 onError:(MKNKErrorBlock) errorBlock;

typedef void (^FeedbackDetailBlock) (NSString *message, Feedback *result);
- (MKNetworkOperation*) feedbackDetail:(NSString *)feedback_id
                          onCompletion:(FeedbackDetailBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock;

typedef void (^FeedbackRateBlock) (NSString *message, bool result);
- (MKNetworkOperation*) feedbackRate:(NSString *)feedback_id
                                rate:(NSString *)rate
                             comment:(NSString *)comment
                        onCompletion:(FeedbackRateBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock;

#pragma mark Announcement
typedef void (^AnnouncementListBlock) (NSString *message, Announcement *result);
- (MKNetworkOperation*) announcementOnCompletion:(AnnouncementListBlock) completionBlock
                                         onError:(MKNKErrorBlock) errorBlock;

#pragma mark Family
typedef void (^FamilyBlock) (NSString *message, NSMutableArray *result);
- (MKNetworkOperation*) familyListOnCompletion:(FamilyBlock) completionBlock
                                       onError:(MKNKErrorBlock) errorBlock;

typedef void (^FamilyRemoveBlock) (NSString *message, bool result);
- (MKNetworkOperation*) familyRemove:(NSString *)family_id
                             pending:(bool)pending
                        onCompletion:(FamilyRemoveBlock) completionBlock
                             onError:(MKNKErrorBlock) errorBlock;

typedef void (^FamilyRegisterBlock) (NSString *message, bool result);
- (MKNetworkOperation*) familyRegister:(NSString *)mobile
                          relationship:(NSString *)relationship
                          onCompletion:(FamilyRegisterBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock;

typedef void (^FamilyActivateBlock) (NSString *message, bool result);
- (MKNetworkOperation*) familyActivate:(NSString *)phone_code
                          onCompletion:(FamilyActivateBlock) completionBlock
                               onError:(MKNKErrorBlock) errorBlock;

#pragma mark Wallet
typedef void (^WalletBlock) (NSString *message, Wallet *result);
- (MKNetworkOperation*) walletOnCompletion:(WalletBlock) completionBlock
                                   onError:(MKNKErrorBlock) errorBlock;

typedef void (^WalletPaymentBlock) (NSString *message, bool result);
- (MKNetworkOperation*) walletPayment:(NSString *)booking_id
                         onCompletion:(WalletPaymentBlock) completionBlock
                              onError:(MKNKErrorBlock) errorBlock;

@end
