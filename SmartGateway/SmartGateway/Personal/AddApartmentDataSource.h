//
//  AddApartmentDataSource.h
//  SmartGateway
//
//  Created by Grace on 26/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPAutoCompleteTextFieldDataSource.h"

@interface AddApartmentDataSource : NSObject <MLPAutoCompleteTextFieldDataSource>

@property (assign) BOOL testWithAutoCompleteObjectsInsteadOfStrings;
@property (assign) BOOL simulateLatency;
//@property (strong, nonatomic) NSArray *countryObjects;

@end
