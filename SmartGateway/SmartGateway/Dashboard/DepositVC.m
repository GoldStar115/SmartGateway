//
//  DepositVC.m
//  SmartGateway
//
//  Created by Grace on 15/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "DepositVC.h"
#import "CalendarVC.h"
#import "BookingRecordsVC.h"
#import "WalletVC.h"

@interface DepositVC ()

@end

@implementation DepositVC

static NSString *kCashCell = @"CashCell";
static NSString *kChequeCell = @"ChequeCell";
static NSString *kOnlinePaymentCell = @"OnlinePaymentCell";
static NSString *kOrderInfoCell = @"OrderInfoCell";
static NSString *kSubmitCell = @"SubmitCell";
static NSString *kSectionHeader = @"SectionHeader";

NSString *location;
NSString *date;
NSString *deposit;
NSString *bookingFee;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    location = @"Badminton Court 1";
//    date = @"2016-3-04 (09:00 - 15:00)";
//    deposit = @"$200";
//    bookingFee = @"$25";
    location = self.booking.facility;
    date = [NSString stringWithFormat:@"%@ (%@)", self.booking.date, self.booking.time];
    deposit = self.booking.deposit;
    bookingFee = self.booking.fee;
    
    info = [NSString stringWithFormat:@"%@\n%@\nDeposit: %@\nBooking Fee: %@", location, date, deposit, bookingFee];;
    [self refresh];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)refresh
{
    groupedArray = [[NSMutableArray alloc] init];
    headerArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:kCashCell];
    [array addObject:kChequeCell];
    [array addObject:kOnlinePaymentCell];
    [groupedArray addObject:array];
    [headerArray addObject:@""];
    
    array = [[NSMutableArray alloc] init];
    [array addObject:kOrderInfoCell];
    [array addObject:kSubmitCell];
    [groupedArray addObject:array];
    [headerArray addObject:@""];
    
    NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    NSString *CellIdentifier = kSectionHeader;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell.contentView.frame.size.height;
    //    return 18;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *CellIdentifier = kSectionHeader;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *sectionName = [headerArray objectAtIndex:section];
    if(!sectionName || sectionName.length == 0)
        return nil;
    
    for(UIView *vw in cell.contentView.subviews)
    {
        if([vw isKindOfClass:[UILabel class]])
        {
            ((UILabel *)vw).text = sectionName;
            break;
        }
    }
    return cell.contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kOrderInfoCell])
    {
//        return 130;
        MaintenanceCell *cell = (MaintenanceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        cell.descriptionLabel.text = info;
        cell.descriptionLabel.attributedText = [self getOrderInfoText:cell];
        return MAX(115, [cell getHeightFromScreenWidth:self.view.frame.size.width]);
    }
    else if([CellIdentifier isEqualToString:kSubmitCell])
    {
        return 80;
    }
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kOrderInfoCell])
    {
        MaintenanceCell *cell = (MaintenanceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        cell.descriptionLabel.text = info;
        cell.descriptionLabel.attributedText = [self getOrderInfoText:cell];
        [cell getHeightFromScreenWidth:self.view.frame.size.width];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if([CellIdentifier isEqualToString:kOnlinePaymentCell])
//    {
////        cell.contentView.alpha = 0.5;
//        ((InviteCell *)cell).iconLabel.alpha = 0.5;
//        ((InviteCell *)cell).nameLabel.alpha = 0.34;
//    }
    
    return cell;
}

- (NSMutableAttributedString *)getOrderInfoText:(MaintenanceCell *)cell
{
    UIFont *boldFont = [UIFont fontWithName:@"Avenir-Black" size:cell.descriptionLabel.font.pointSize];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:info];
    NSRange nameRange = [info.lowercaseString rangeOfString:location.lowercaseString];
    [string addAttribute:NSFontAttributeName value:boldFont range:nameRange];
    return string;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        [self refresh];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kCashCell] ||
       [CellIdentifier isEqualToString:kChequeCell] ||
       [CellIdentifier isEqualToString:kOnlinePaymentCell])
    {
        return indexPath;
    }
    
    if([CellIdentifier isEqualToString:kSubmitCell])
    {
//        [self.navigationController popViewControllerAnimated:YES];
        [self bookingConfirm];
    }
    return nil;
}

- (void)bookingConfirm
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] bookingConfirm:[self.session_ids componentsJoinedByString:@","]
                      payment_type:[NSString stringWithFormat:@"%ld", indexPath.row+1]
                      onCompletion:^(NSString *message, bool result) {
                          [SVProgressHUD dismiss];
//                          [self showPopup];
                          if(message)
                          {
                              [self showPopUp:message onCompletion:^(UIButton *sender) {
                                  [self backToBookingRecordsView];
                              }];
                          }
                          else
                              [self backToBookingRecordsView];
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"BookingReload" object:nil];
                      }
                           onError:^(NSError* error) {
                               [SVProgressHUD dismiss];
                               if(error.code == 428)
                               {
                                   UIAlertController * alert=   [UIAlertController
                                                                 alertControllerWithTitle:[error localizedDescription]
                                                                 message:[error localizedRecoverySuggestion]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                   UIAlertAction* walletButton = [UIAlertAction
                                                                  actionWithTitle:@"SG Wallet"
                                                                  style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                                                  {
                                                                      UIStoryboard *sb = self.storyboard;
                                                                      WalletVC *vc = [sb instantiateViewControllerWithIdentifier:@"WalletVC"];
                                                                      [self.navigationController pushViewController:vc animated:YES];
                                                                  }];
                                   UIAlertAction* laterButton = [UIAlertAction
                                                                 actionWithTitle:@"Later"
                                                                 style:UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction * action)
                                                                 {
                                                                     [self backToBookingRecordsView];
                                                                 }];
                                   [alert addAction:walletButton];
                                   [alert addAction:laterButton];
                                   [self presentViewController:alert animated:YES completion:nil];
                               }
                               else
                                   [self showError:error];
//                               [UIAlertView showWithError:error];
                           }
     ];
}

- (void)showPopup
{
//    [self.navigationController popViewControllerAnimated:YES];
    UIStoryboard *sb = self.storyboard;
    PopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"DepositPopupVC"];
//    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

- (void)backToBookingRecordsView
{
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[BookingRecordsVC class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    UIStoryboard *sb = self.storyboard;
    BookingRecordsVC *vc = [sb instantiateViewControllerWithIdentifier:@"BookingRecordsVC"];
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [vcs insertObject:vc atIndex:1];
    [self.navigationController setViewControllers:vcs];
    [self.navigationController popToViewController:vc animated:YES];
    
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PopupDelegate
- (void)popup:(PopupVC *)vc didClickYes:(id)sender
{
    //    [self.navigationController popViewControllerAnimated:YES];
    [vc dismissViewControllerAnimated:YES completion:^{
        [self backToBookingRecordsView];
    }];
}

- (void)popup:(PopupVC *)vc didClickCancel:(id)sender
{
    //    [self.navigationController popViewControllerAnimated:YES];
    [vc dismissViewControllerAnimated:NO completion:nil];
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
