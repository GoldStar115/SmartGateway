//
//  BookingDetailVC.m
//  SmartGateway
//
//  Created by Grace on 9/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "BookingDetailVC.h"
#import "WalletVC.h"

@interface BookingDetailVC ()

@end

@implementation BookingDetailVC

static NSString *kBookingCell = @"BookingCell";
static NSString *kDepositDeductedCell = @"DepositDeductedCell";
static NSString *kReasonCell = @"ReasonCell";
static NSString *kTimeCell = @"TimeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] bookingDetail:self.booking.booking_id
                     onCompletion:^(NSString *message, BookingDetail *result) {
                         [SVProgressHUD dismiss];
                         [self showPopUp:message];
                         
                         bdetail = result;
                         reason = @"1.  Chairs were damaged by burnt cigarettes\
                         \n2.  3 drinking glasses were broken";
                         
                         groupedArray = [[NSMutableArray alloc] init];
                         headerArray = [[NSMutableArray alloc] init];
                         
                         NSMutableArray *array = [[NSMutableArray alloc] init];
                         [array addObject:kBookingCell];
                         [array addObject:kDepositDeductedCell];
//                         [array addObject:kReasonCell];
                         [groupedArray addObject:array];
                         [headerArray addObject:@""];
                         
                         array = [[NSMutableArray alloc] init];
                         [array addObject:kTimeCell];
                         [array addObject:kTimeCell];
                         [array addObject:kTimeCell];
                         [groupedArray addObject:array];
                         [headerArray addObject:@""];
                         
                         [self.tableView reloadData];
                     }
                          onError:^(NSError* error) {
                              [SVProgressHUD dismiss];
//                              [UIAlertView showWithError:error];
                              [self showError:error onCompletion:^(UIButton *sender) {
                                  if(!bdetail)
                                      [self popViewController];
                              }];

                          }
     ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makePaymentClicked:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] walletPayment:self.booking.booking_id
                     onCompletion:^(NSString *message, bool result) {
                         [SVProgressHUD dismiss];
                         if(message)
                         {
                             [self showPopUp:message onCompletion:^(UIButton *sender) {
                                 [self popViewController];
                                 //[self refresh];
                             }];
                         }
                         else
                             [self popViewController];
                             //[self refresh];
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
                                                                     [self popViewController];
                                                                 }];
                                  [alert addAction:walletButton];
                                  [alert addAction:laterButton];
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                              else
                                  [self showError:error];
                              
                          }
     ];
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
    return 18;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    if([CellIdentifier isEqualToString:kBookingCell])
        return 115;
    else if([CellIdentifier isEqualToString:kReasonCell])
    {
        BookingCell *cell = (BookingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        cell.descriptionLabel.text = reason;
//        float height = [dm getTextHeightFromLabel:cell.descriptionLabel];
//        return MAX(75, height+15+38);
        return MAX(75, [cell getHeightFromScreenWidth:self.view.frame.size.width]);

    }
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    BookingCell *cell = (BookingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([CellIdentifier isEqualToString:kBookingCell])
    {
//        NSString *dateString = @"31 Mar 2016";
//        NSString *description = @"BBQ Pit No. 20 (09:00 - 15:00)";
//        NSString *status = @"Refunding";
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMM yyyy"];
        NSDate *date = [[dm serverDateFormatter] dateFromString:bdetail.booking.date];
        
        NSString *dateString = [df stringFromDate:date];
        NSString *description = [NSString stringWithFormat:@"%@ (%@)", bdetail.booking.facility, bdetail.booking.time];
        NSString *status = bdetail.booking.state;
        
        cell.nameLabel.text = dateString;
        cell.descriptionLabel.text = description;
        [cell setStatus:status];
    }
    else if([CellIdentifier isEqualToString:kDepositDeductedCell])
    {
        cell.nameLabel.text = bdetail.booking.payment_msg;
        cell.descriptionLabel.text = bdetail.booking.payment_amt;
//        cell.descriptionLabel.text = @"$100";
//        cell.descriptionLabel.text = bdetail.booking.deposit;
    }
    else if([CellIdentifier isEqualToString:kReasonCell])
    {
        cell.descriptionLabel.text = reason;
        [cell getHeightFromScreenWidth:self.view.frame.size.width];
    }
    else if([CellIdentifier isEqualToString:kTimeCell])
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMM yyyy HH:mm"];
        
        NSDate *date = nil;
        NSString *titleString = @"";
        NSString *dateString = @"-";
        if(indexPath.row == 0)
        {
            titleString = @"Booking Time";
//            dateString = @"24 Feb 2016 14:40";
            date = [[dm serverDateLongFormatter] dateFromString:bdetail.booking.booking_time];
        }
        else if(indexPath.row == 1)
        {
            titleString = @"Confirmed Time";
//            dateString = @"25 Feb 2016 08:40";
            date = [[dm serverDateLongFormatter] dateFromString:bdetail.confirmed];
        }
        else //if(indexPath.row == 2)
        {
            titleString = @"Refunded Time";
//            dateString = @"25 Feb 2016 16:40";
            date = [[dm serverDateLongFormatter] dateFromString:bdetail.refunded];
        }
        
        if(date)
            dateString = [df stringFromDate:date];
        
        cell.nameLabel.text = titleString;
        cell.descriptionLabel.text = dateString;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
