//
//  BookingRecordsVC.m
//  SmartGateway
//
//  Created by Grace on 9/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "BookingRecordsVC.h"
#import "BookingDetailVC.h"
#import "FacilityBookingVC.h"

@interface BookingRecordsVC ()

@end

@implementation BookingRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"BookingReload" object:nil];
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] bookingListOnCompletion:^(NSString *message, NSMutableArray *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        
        bookingArray = result;
        [self.tableView reloadData];
    }
                                    onError:^(NSError* error) {
                                        [SVProgressHUD dismiss];
//                                        [UIAlertView showWithError:error];
                                        [self showError:error onCompletion:^(UIButton *sender) {
                                            if(!bookingArray)
                                                [self popViewController];
                                        }];
                                    }
     ];

}

- (IBAction)addBookingClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    FacilityBookingVC *vc = [sb instantiateViewControllerWithIdentifier:@"FacilityBookingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return bookingArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"BookingCell";
    BookingCell *cell = (BookingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    NSString *dateString = @"31 Mar 2016";
//    NSString *description = @"BBQ Pit No. 20 (09:00 - 15:00)";
//    NSString *status = @"Refunding";
//    
//    if(indexPath.row == 0)
//    {
//        dateString = @"24 Feb 2016";
//        description = @"Badminton Court (19:00 - 20:00)";
//        status = @"Confirmed";
//    }
//    else if(indexPath.row == 1)
//    {
//        dateString = @"22 Feb 2016";
//        description = @"BBQ Pit No. 20 (09:00 - 15:00)";
//        status = @"Waiting";
//    }
//    else if(indexPath.row == 2)
//    {
//        dateString = @"01 Feb 2016";
//        description = @"BBQ Pit No. 10 (09:00 - 14:00)";
//        status = @"Refunded";
//    }

    Booking *booking = [bookingArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy"];
    NSDate *date = [[dm serverDateFormatter] dateFromString:booking.date];
    
    NSString *dateString = [df stringFromDate:date];;
    NSString *description = [NSString stringWithFormat:@"%@ (%@)", booking.facility, booking.time];
    NSString *status = booking.state;
    
    cell.nameLabel.text = dateString;
    cell.descriptionLabel.text = description;
    [cell setStatus:status];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Booking *booking = [bookingArray objectAtIndex:indexPath.row];
    
    UIStoryboard *sb = self.storyboard;
    BookingDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"BookingDetailVC"];
    vc.booking = booking;
    [self.navigationController pushViewController:vc animated:YES];

    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:[NSString stringWithFormat:@"Are you sure you want to cancel this booking?"]
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       Booking *booking = [bookingArray objectAtIndex:indexPath.row];
                                       [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                                       [[dm apiEngine] bookingCancel:booking.booking_id
                                                        onCompletion:^(NSString *message, bool result) {
                                                            [SVProgressHUD dismiss];
                                                            [self showPopUp:message];
                                                            [self refresh];
                                                        }
                                                             onError:^(NSError* error) {
                                                                 [SVProgressHUD dismiss];
                                                                 //[UIAlertView showWithError:error];
                                                                 [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                                 [self showError:error];
                                                             }
                                        ];
                                   }];
        UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDestructive
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                       }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
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

@end
