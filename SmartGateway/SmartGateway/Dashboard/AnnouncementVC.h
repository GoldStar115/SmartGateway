//
//  AnnouncementVC.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "AnnouncementCell.h"

@interface AnnouncementVC : TableViewController
{
    NSMutableArray *groupedArray;
    NSMutableArray *headerArray;

    IBOutlet UIButton *condoButton;
    IBOutlet UIButton *systemButton;
    
    Announcement *announcement;
}

@end
