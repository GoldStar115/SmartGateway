//
//  CalendarVC.h
//  SmartGateway
//
//  Created by Grace on 13/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ViewController.h"
#import "CalendarCell.h"

@interface CalendarVC : ViewController
{
    IBOutlet UIView *courtView;
    IBOutlet UIButton *courtButton;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *headerImage;
    
    IBOutlet UILabel *monthLabel;
    IBOutlet UIView *dayView;
    
    NSMutableArray *facilityArray;
    
    int selectedIndex;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) FacilityType *facilityType;
@end
