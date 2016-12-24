//
//  DashboardVC.h
//  SmartGateway
//
//  Created by Grace on 8/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ViewController.h"
#import "DashboardHeaderView.h"

@interface DashboardVC : ViewController <DashboardHeaderDelegate>
{
    IBOutlet DashboardHeaderView *headerView;
    IBOutlet UIButton *defaultCondoButton;
    NSMutableArray *cellArray;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end
