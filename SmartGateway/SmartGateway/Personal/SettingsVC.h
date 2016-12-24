//
//  SettingsVC.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "SettingsCell.h"

@interface SettingsVC : TableViewController
{
    NSMutableArray *cellArray;
    
    bool soundOn;
}

@end
