//
//  Wallet.h
//  SmartGateway
//
//  Created by Grace on 19/8/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wallet : NSObject

@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *history_url;
@property (nonatomic, strong) NSString *purchase_url;
@property (nonatomic, strong) NSString *topup_url;
@property (nonatomic, strong) NSString *transfer_url;

@end
