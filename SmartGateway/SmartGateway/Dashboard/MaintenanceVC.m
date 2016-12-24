//
//  MaintenanceVC.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "MaintenanceVC.h"
#import "AddMaintenanceVC.h"
#import "MaintenanceDetailVC.h"

@interface MaintenanceVC ()

@end

@implementation MaintenanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"MaintenanceReload" object:nil];
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] maintenanceListOnCompletion:^(NSString *message, NSMutableArray *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        maintenanceArray = result;
        [self.tableView reloadData];
    }
                                        onError:^(NSError* error) {
                                            [SVProgressHUD dismiss];
//                                            [UIAlertView showWithError:error];
                                            [self showError:error onCompletion:^(UIButton *sender) {
                                                if(!maintenanceArray)
                                                    [self popViewController];
                                            }];
                                        }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    AddMaintenanceVC *vc = [sb instantiateViewControllerWithIdentifier:@"AddMaintenanceVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return maintenanceArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"MaintenanceCell";
    MaintenanceCell *cell = (MaintenanceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    NSString *dateString = @"22 Feb 2016";
//    NSString *item = @"Light Fuse Blown";
//    NSString *apartement = @"D’Hillside Loft Condo";
//    NSString *block = @"4";
//    NSString *unit = @"4";
//    NSString *status = @"Fixing In Progress";
    
//    if(indexPath.row == 0)
//    {
//        dateString = @"24 Feb 2016";
//        item = @"Tap Leaking";
//        apartement = @"D’Hillside Loft Condo";
//        block = @"4";
//        unit = @"4";
//        status = @"Completed";
//    }

    Maintenance *maintenance = [maintenanceArray objectAtIndex:indexPath.row];
    NSDate *date = [[dm serverDateLongFormatter] dateFromString:maintenance.date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy"];
    
    NSString *dateString = [df stringFromDate:date];
    NSString *item = maintenance.item;
    NSString *apartement = maintenance.condo;
    NSString *block = maintenance.block;
    NSString *unit = maintenance.unit;
    NSString *status = maintenance.status;
    
    cell.nameLabel.text = dateString;
    cell.descriptionLabel.text = [NSString stringWithFormat:@"Subject: %@\n%@\nBlock %@ Unit %@", item, apartement, block, unit];
    [cell setStatus:status];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Maintenance *maintenance = [maintenanceArray objectAtIndex:indexPath.row];
    
    UIStoryboard *sb = self.storyboard;
    MaintenanceDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"MaintenanceDetailVC"];
    vc.maintenance = maintenance;
    [self.navigationController pushViewController:vc animated:YES];
    
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
