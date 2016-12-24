//
//  AddApartmentCustomAutoCompleteObject.h
//  SmartGateway
//
//  Created by Grace on 26/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPAutoCompletionObject.h"

@interface AddApartmentCustomAutoCompleteObject : NSObject <MLPAutoCompletionObject>

- (id)initWithCondo:(Condo *)condo;
@property (strong) Condo *condo;

@end
