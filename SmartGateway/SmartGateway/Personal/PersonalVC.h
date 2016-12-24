//
//  PersonalVC.h
//  SmartGateway
//
//  Created by Grace on 8/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "PersonalCell.h"
#import "PersonalHeaderView.h"

@interface PersonalVC : TableViewController
{
    NSMutableArray *groupedArray;
    NSMutableArray *headerArray;
}

@property (nonatomic, strong) IBOutlet PersonalHeaderView *headerView;

@end
