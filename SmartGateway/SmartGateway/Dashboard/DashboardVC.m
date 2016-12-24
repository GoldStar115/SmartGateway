//
//  DashboardVC.m
//  SmartGateway
//
//  Created by Grace on 8/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "DashboardVC.h"
#import "FacilityBookingVC.h"
#import "AddMaintenanceVC.h"
#import "SubmitFeedbackVC.h"
#import "MyApartementVC.h"
#import "AnnouncementVC.h"
#import "SettingsVC.h"
#import "InviteActivateMemberVC.h"
#import "BookingRecordsVC.h"
#import "MaintenanceVC.h"
#import "FeedbackVC.h"
#import "AddMaintenanceVC.h"
#import "AddFeedbackVC.h"
#import "FacilityBookingVC.h"
#import "WebviewVC.h"
#import "CalendarVC.h"
#import "WalletVC.h"

#define kFacilityBookingCell @"FacilityBookingCell"
#define kMaintenanceCell @"MaintenanceCell"
#define kFeedbackCell @"FeedbackCell"
#define kWalletCell @"WalletCell"
#define kInviteCell @"InviteCell"
#define kPropertyCell @"PropertyCell"

@interface DashboardVC ()

@end

@implementation DashboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //enable swipe back
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDefaultCondo) name:@"PersonalReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToLoginScreen) name:@"Logout" object:nil];

//    [self updateView];
//    [self updateDefaultCondo];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateView];
    [self updateDefaultCondo];
    
}

- (void)backToLoginScreen
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateView
{
    cellArray = [[NSMutableArray alloc] init];
    [cellArray addObject:kFacilityBookingCell];
    [cellArray addObject:kMaintenanceCell];
    [cellArray addObject:kFeedbackCell];
    [cellArray addObject:kWalletCell];
    [cellArray addObject:kInviteCell];
    [cellArray addObject:kPropertyCell];
    
    [self.collectionView reloadData];
}

- (void)updateDefaultCondo
{
    if([dm cUser].default_condo && [dm cUser].default_condo.length > 0)
    {
        [defaultCondoButton setTitle:[dm cUser].default_condo forState:UIControlStateSelected];
        defaultCondoButton.selected = YES;
    }
    else
    {
        defaultCondoButton.selected = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingsClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    SettingsVC *vc = [sb instantiateViewControllerWithIdentifier:@"SettingsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)notificationClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    AnnouncementVC *vc = [sb instantiateViewControllerWithIdentifier:@"AnnouncementVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pickYourApartementClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    MyApartementVC *vc = [sb instantiateViewControllerWithIdentifier:@"MyApartementVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return cellArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierString = [cellArray objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierString forIndexPath:indexPath];
    // Configure the cell
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    
    headerView = (DashboardHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:
                                      UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headerView.delegate = self;
    [headerView refresh];
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    float w = [[UIScreen mainScreen] bounds].size.width;
    return CGSizeMake(w, w * 0.24);
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w = [[UIScreen mainScreen] bounds].size.width /2;
    return CGSizeMake(w, w);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierString = [cellArray objectAtIndex:indexPath.row];
    if([identifierString isEqualToString:kFacilityBookingCell])
    {
        UIStoryboard *sb = self.storyboard;
        FacilityBookingVC *vc = [sb instantiateViewControllerWithIdentifier:@"FacilityBookingVC"];
//        BookingRecordsVC *vc = [sb instantiateViewControllerWithIdentifier:@"BookingRecordsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([identifierString isEqualToString:kMaintenanceCell])
    {
        UIStoryboard *sb = self.storyboard;
        AddMaintenanceVC *vc = [sb instantiateViewControllerWithIdentifier:@"AddMaintenanceVC"];
//        MaintenanceVC *vc = [sb instantiateViewControllerWithIdentifier:@"MaintenanceVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([identifierString isEqualToString:kFeedbackCell])
    {
        UIStoryboard *sb = self.storyboard;
//        SubmitFeedbackVC *vc = [sb instantiateViewControllerWithIdentifier:@"SubmitFeedbackVC"];
//        FeedbackVC *vc = [sb instantiateViewControllerWithIdentifier:@"FeedbackVC"];
        AddFeedbackVC *vc = [sb instantiateViewControllerWithIdentifier:@"AddFeedbackVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([identifierString isEqualToString:kWalletCell])
    {
        UIStoryboard *sb = self.storyboard;
        WalletVC *vc = [sb instantiateViewControllerWithIdentifier:@"WalletVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([identifierString isEqualToString:kPropertyCell])
    {
        if([dm urls].property_url && [dm urls].property_url.length > 0)
        {
            UIStoryboard *sb = self.storyboard;
            WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
            vc.urlString = [dm urls].property_url;
            vc.title = @"Property";
            [self.navigationController pushViewController:vc animated:YES];
        }        
    }
    else if([identifierString isEqualToString:kInviteCell])
    {
        UIStoryboard *sb = self.storyboard;
        InviteActivateMemberVC *vc = [sb instantiateViewControllerWithIdentifier:@"InviteActivateMemberVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - DashboardHeaderDelegate
- (void)header:(DashboardHeaderView *)view didClickUrl:(NSString *)urlString
{
    UIStoryboard *sb = self.storyboard;
    WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
    vc.urlString = urlString;
//    vc.title = cellID;
    [self.navigationController pushViewController:vc animated:YES];
    
//    UIStoryboard *sb = self.storyboard;
//    CalendarVC *vc = [sb instantiateViewControllerWithIdentifier:@"CalendarVC"];
//    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
