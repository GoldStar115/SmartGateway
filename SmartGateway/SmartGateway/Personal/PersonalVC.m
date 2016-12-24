//
//  PersonalVC.m
//  SmartGateway
//
//  Created by Grace on 8/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "PersonalVC.h"
#import "BookingRecordsVC.h"
#import "MyApartementVC.h"
#import "MaintenanceVC.h"
#import "FeedbackVC.h"
#import "SettingsVC.h"
#import "MyProfileVC.h"
#import "MyFamilyVC.h"
#import "WebviewVC.h"
#import "WalletVC.h"

#import "UIImageView+WebCache.h"

@interface PersonalVC ()

@end

@implementation PersonalVC

static NSString *kApartementCell = @"My Apartment";
static NSString *kProfileCell = @"My Profile";
static NSString *kFamilyCell = @"My Family";
static NSString *kBookingCell = @"My Bookings";
static NSString *kMaintenanceCell = @"My Maintenance";
static NSString *kFeedbackCell = @"My Feedback";
static NSString *kSettingsCell = @"Settings";
static NSString *kAboutCell = @"About";
static NSString *kAgreementCell = @"Agreement";
static NSString *kLogoutCell = @"Logout";
static NSString *kWalletCell = @"SG Wallet";
static NSString *kSectionHeader = @"SectionHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    groupedArray = [[NSMutableArray alloc] init];
    headerArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:kApartementCell];
    [array addObject:kProfileCell];
    [array addObject:kFamilyCell];
    [groupedArray addObject:array];
    [headerArray addObject:@""];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:kWalletCell];
    [groupedArray addObject:array];
    [headerArray addObject:@"  "];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:kBookingCell];
    [array addObject:kMaintenanceCell];
    [array addObject:kFeedbackCell];
    [groupedArray addObject:array];
    [headerArray addObject:@"  "];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:kSettingsCell];
    [array addObject:kAboutCell];
    [array addObject:kAgreementCell];
    [array addObject:kLogoutCell];
    [groupedArray addObject:array];
    [headerArray addObject:@"  "];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"PersonalReload" object:nil];
//    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)refresh
{
    if([dm cUser])
    {
//        self.headerView.iconImageView.image = [dm decodeBase64ToImage:[dm cUser].image];
        [self.headerView.iconImageView setBackgroundColor:[UIColor whiteColor]];
        if ([dm cUser].image_url != nil && ![[dm cUser].image_url isEqualToString:@""]){
            [self.headerView.iconImageView sd_setImageWithURL:[NSURL URLWithString:[dm cUser].image_url]];
        }else{
            if ([dm cUser].image != nil)
                self.headerView.iconImageView.image = [dm decodeBase64ToImage:[dm cUser].image];
        }
        
        self.headerView.nameLabel.text = [dm cUser].name;
        self.headerView.descriptionLabel.text = [dm cUser].default_condo;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return headerArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arr = [groupedArray objectAtIndex:section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(((NSString *)[headerArray objectAtIndex:section]).length == 0)
        return 0;
    return 18;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *CellIdentifier = kSectionHeader;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *sectionName = [headerArray objectAtIndex:section];
    if(!sectionName || sectionName.length == 0)
        return nil;
    
//    for(UIView *vw in cell.contentView.subviews)
//    {
//        if([vw isKindOfClass:[UILabel class]])
//        {
//            ((UILabel *)vw).text = sectionName;
//            break;
//        }
//    }
    return cell.contentView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *cellID = [arr objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = @"PersonalCell";
    if([cellID isEqualToString:kWalletCell])
        CellIdentifier = @"WalletCell";
    PersonalCell *cell = (PersonalCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.nameLabel.text = cellID;
    cell.badgeLabel.hidden = YES;
    UIColor *color;
    if(indexPath.section == 0)
        color = [UIColor colorWithRed:242/255.0 green:109/255.0 blue:125/255.0 alpha:1.0];
    else if(indexPath.section == 1)
        color = [UIColor colorWithRed:40/255.0 green:167/255.0 blue:225/255.0 alpha:1.0];
    else
        color = [UIColor colorWithRed:141/255.0 green:198/255.0 blue:63/255.0 alpha:1.0];
    cell.iconLabel.textColor = color;
    
    if([cellID isEqualToString:kApartementCell])
    {
        cell.iconLabel.text = @"";
    }
    else if([cellID isEqualToString:kProfileCell])
    {
        cell.iconLabel.text = @"";
    }
    else if([cellID isEqualToString:kFamilyCell])
    {
        cell.iconLabel.text = @"";
    }
    
    else if([cellID isEqualToString:kBookingCell])
    {
        cell.iconLabel.text = @"";
//        cell.badgeLabel.hidden = NO;
//        cell.badgeLabel.text = @"2";
    }
    else if([cellID isEqualToString:kMaintenanceCell])
    {
        cell.iconLabel.text = @"";
//        cell.badgeLabel.hidden = NO;
//        cell.badgeLabel.text = @"1";
    }
    else if([cellID isEqualToString:kFeedbackCell])
    {
        cell.iconLabel.text = @"";
    }
    
    else if([cellID isEqualToString:kSettingsCell])
    {
        cell.iconLabel.text = @"";
    }
    else if([cellID isEqualToString:kAboutCell])
    {
        cell.iconLabel.text = @"";
    }
    else if([cellID isEqualToString:kAgreementCell])
    {
        cell.iconLabel.text = @"";
    }
    else if([cellID isEqualToString:kLogoutCell])
    {
        cell.iconLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *cellID = [arr objectAtIndex:indexPath.row];
    
    if([cellID isEqualToString:kApartementCell])
    {
        UIStoryboard *sb = self.storyboard;
        MyApartementVC *vc = [sb instantiateViewControllerWithIdentifier:@"MyApartementVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kProfileCell])
    {
        UIStoryboard *sb = self.storyboard;
        MyProfileVC *vc = [sb instantiateViewControllerWithIdentifier:@"MyProfileVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kFamilyCell])
    {
        UIStoryboard *sb = self.storyboard;
        MyFamilyVC *vc = [sb instantiateViewControllerWithIdentifier:@"MyFamilyVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kWalletCell])
    {
        UIStoryboard *sb = self.storyboard;
        WalletVC *vc = [sb instantiateViewControllerWithIdentifier:@"WalletVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kBookingCell])
    {
        UIStoryboard *sb = self.storyboard;
        BookingRecordsVC *vc = [sb instantiateViewControllerWithIdentifier:@"BookingRecordsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kMaintenanceCell])
    {
        UIStoryboard *sb = self.storyboard;
        MaintenanceVC *vc = [sb instantiateViewControllerWithIdentifier:@"MaintenanceVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kFeedbackCell])
    {
        UIStoryboard *sb = self.storyboard;
        FeedbackVC *vc = [sb instantiateViewControllerWithIdentifier:@"FeedbackVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kSettingsCell])
    {
        UIStoryboard *sb = self.storyboard;
        SettingsVC *vc = [sb instantiateViewControllerWithIdentifier:@"SettingsVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kAboutCell])
    {
        UIStoryboard *sb = self.storyboard;
        WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
        vc.urlString = [dm urls].about_url;
        vc.title = cellID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kAgreementCell])
    {
        UIStoryboard *sb = self.storyboard;
        WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
        vc.urlString = [dm urls].agreement_url;
        vc.title = cellID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([cellID isEqualToString:kLogoutCell])
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:[NSString stringWithFormat:@"Are you sure you want to logout?"]
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                    actionWithTitle:@"No"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
        UIAlertAction* logoutButton = [UIAlertAction
                                   actionWithTitle:@"Logout"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * action)
                                   {
                                       [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                                       [[dm apiEngine] logout:^(NSString *message, bool result) {
                                           [SVProgressHUD dismiss];
                                           [dm logout];
                                           if(message)
                                           {
                                               [self showPopUp:message onCompletion:^(UIButton *sender) {
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
                                               }];
                                           }
                                           else
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil];
                                       }
                                                      onError:^(NSError* error) {
                                                          [SVProgressHUD dismiss];
//                                                          [UIAlertView showWithError:error];
                                                          [self showError:error onCompletion:^(UIButton *sender) {
                                                              [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                              [dm logout];
                                                          }];
                                                      }
                                        ];
                                   }];
        [alert addAction:noButton];
        [alert addAction:logoutButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    return nil;
}


@end
