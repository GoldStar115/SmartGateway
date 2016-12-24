//
//  BookingVC.m
//  SmartGateway
//
//  Created by Grace on 15/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "BookingVC.h"
#import "DepositVC.h"

@interface BookingVC ()

@end

@implementation BookingVC

static NSString *kSectionHeader = @"SectionHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] facilitySession:self.facility.fid
                               date:self.facilityDate.bookdate
                       onCompletion:^(NSString *message, Facility *result) {
                        [SVProgressHUD dismiss];
                           [self showPopUp:message];
                           self.facility = result;
                           [self.tableView reloadData];
                    }
                         onError:^(NSError* error) {
                             [SVProgressHUD dismiss];
//                             [UIAlertView showWithError:error];
                             [self showError:error onCompletion:^(UIButton *sender) {
                                 if(!self.facility)
                                 [self popViewController];
                             }];
                         }
     ];
    
//    cellArray = [[NSMutableArray alloc] init];
//    [cellArray addObject:@"7:00am - 8:00am"];
//    [cellArray addObject:@"8:00am - 9:00am"];
//    [cellArray addObject:@"9:00am - 10:00am"];
//    [cellArray addObject:@"10:00am - 11:00am"];
//    [cellArray addObject:@"11:00am - 12:00pm"];
//    [cellArray addObject:@"1:00pm - 2:00pm"];
//    [cellArray addObject:@"2:00pm - 3:00pm"];
//    [cellArray addObject:@"3:00pm - 4:00pm"];
//    [cellArray addObject:@"4:00pm - 5:00pm"];
//    [cellArray addObject:@"5:00pm - 6:00pm"];
//    [cellArray addObject:@"6:00pm - 7:00pm"];
//    [cellArray addObject:@"7:00pm - 8:00pm"];
//    [cellArray addObject:@"8:00pm - 9:00pm"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)confirmClicked:(id)sender
{
    NSArray *arr = [self.tableView indexPathsForSelectedRows];
    if(arr && arr.count > 0)
    {
        NSMutableArray *session_ids = [[NSMutableArray alloc] init];
        for(NSIndexPath *indexPath in arr)
        {
            FacilityTime *ftime = [self.facility.times objectAtIndex:indexPath.row];
            [session_ids addObject:ftime.session_id];
        }
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[dm apiEngine] booking:[session_ids componentsJoinedByString:@","]
                   onCompletion:^(NSString *message, Booking *result) {
                       [SVProgressHUD dismiss];
                       
                       if(message)
                       {
                           [self showPopUp:message onCompletion:^(UIButton *sender) {
                               UIStoryboard *sb = self.storyboard;
                               DepositVC *vc = [sb instantiateViewControllerWithIdentifier:@"DepositVC"];
                               vc.booking = result;
                               vc.session_ids = session_ids;
                               [self.navigationController pushViewController:vc animated:YES];
                           }];
                       }
                       else
                       {
                           UIStoryboard *sb = self.storyboard;
                           DepositVC *vc = [sb instantiateViewControllerWithIdentifier:@"DepositVC"];
                           vc.booking = result;
                           vc.session_ids = session_ids;
                           [self.navigationController pushViewController:vc animated:YES];
                       }
                   }
                        onError:^(NSError* error) {
                            [SVProgressHUD dismiss];
//                            [UIAlertView showWithError:error];
                            [self showError:error];
                        }
         ];
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:[NSString stringWithFormat:@"You will need to select at least one slot to book."]
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.facility.times.count;
//    return cellArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
//    if([CellIdentifier isEqualToString:kSubmitCell])
//        return 80;
//    else if([CellIdentifier isEqualToString:kSummaryCell])
//        return 163;
//    return 90;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(((NSString *)[headerArray objectAtIndex:section]).length == 0)
//        return 0;
    
    NSString *CellIdentifier = kSectionHeader;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell.contentView.frame.size.height;
    //    return 18;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *CellIdentifier = kSectionHeader;
    BookingCell *cell = (BookingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDate *date = [[dm serverDateFormatter] dateFromString:self.facilityDate.bookdate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMMM yyyy"];
    
    cell.nameLabel.text = self.facility.name;
    cell.descriptionLabel.text = [df stringFromDate:date];    
//    cell.nameLabel.text = @"Court 2";
//    cell.descriptionLabel.text = @"22 April 2016";
    
    return cell.contentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"BookingCell";
//    NSString *name = [cellArray objectAtIndex:indexPath.row];
    BookingCell *cell = (BookingCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    FacilityTime *ftime = [self.facility.times objectAtIndex:indexPath.row];
//    cell.nameLabel.text = name;
    
    NSString *status = [self getStatusAtRow:indexPath];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ - %@", ftime.start , ftime.end];
//    cell.descriptionLabel.hidden = !ftime.peak.boolValue;
    cell.descriptionLabel.hidden = ![self isPeakAtRow:indexPath];
    [cell setStatus:status];
    if(status.length == 0 || [status.lowercaseString isEqualToString:@"bookable"])
        cell.statusButton.hidden = YES;
    else
        cell.statusButton.hidden = NO;
    return cell;
}

- (bool)isPeakAtRow:(NSIndexPath *)indexPath
{
    FacilityTime *ftime = [self.facility.times objectAtIndex:indexPath.row];
    return ftime.peak.boolValue;
    
//    int row = (int)indexPath.row;
//    if(row == 3 || row > 8)
//        return YES;
//    return NO;
}

- (NSString *)getStatusAtRow:(NSIndexPath *)indexPath
{
    FacilityTime *ftime = [self.facility.times objectAtIndex:indexPath.row];
    return ftime.status;
    
//    int row = (int)indexPath.row;
//    if(row == 3 || row == 8 || row == 9 || row == 10)
//        return @"Booked";
//    if(row == 4)
//        return @"Blocked";
//    return @"";
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *name = [cellArray objectAtIndex:indexPath.row];
    NSString *status = [self getStatusAtRow:indexPath];
    if(status.length == 0 || [status.lowercaseString isEqualToString:@"bookable"])
        return indexPath;
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
