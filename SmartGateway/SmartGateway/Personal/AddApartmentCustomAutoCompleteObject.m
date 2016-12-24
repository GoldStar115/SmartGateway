//
//  AddApartmentCustomAutoCompleteObject.m
//  SmartGateway
//
//  Created by Grace on 26/7/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "AddApartmentCustomAutoCompleteObject.h"

@interface AddApartmentCustomAutoCompleteObject ()
@end

@implementation AddApartmentCustomAutoCompleteObject

- (id)initWithCondo:(Condo *)condo
{
    self = [super init];
    if (self) {
        [self setCondo:condo];
    }
    return self;
}

#pragma mark - MLPAutoCompletionObject Protocl

- (NSString *)autocompleteString
{
    return self.condo.name;
}

@end
