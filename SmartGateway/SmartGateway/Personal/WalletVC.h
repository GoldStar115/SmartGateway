//
//  WalletVC.h
//  SmartGateway
//
//  Created by Grace on 18/8/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ViewController.h"

@interface WalletVC : ViewController
{
    IBOutlet UILabel *balanceLabel;
    Wallet *wallet;
}

@end
