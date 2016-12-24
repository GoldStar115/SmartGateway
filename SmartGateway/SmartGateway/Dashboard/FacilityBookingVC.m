//
//  FacilityBookingVC.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "FacilityBookingVC.h"
#import "CalendarVC.h"

@interface FacilityBookingVC ()

@end

@implementation FacilityBookingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] facilityOnCompletion:^(NSString *message, NSMutableArray *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        typeArray = result;
        [self.tableView reloadData];
    }
                                 onError:^(NSError* error) {
                                     [SVProgressHUD dismiss];
//                                     [UIAlertView showWithError:error];
                                     [self showError:error onCompletion:^(UIButton *sender) {
                                         if(!typeArray)
                                             [self popViewController];
                                     }];

//                                     if(!typeArray)
//                                         [self popViewControllerAnimated:NO];
//                                     [self showError:error];
                                 }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
    return typeArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"FacilityCell";
    FacilityCell *cell = (FacilityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    /*NSString *facilityName = @"Multi - Purpose Room";
    UIImage *image = [UIImage imageNamed:@"facility-multi.png"];
    
    if(indexPath.row == 0)
    {
        facilityName = @"Badminton";
        image = [UIImage imageNamed:@"facility-badminton"];
    }
    else if(indexPath.row == 1)
    {
        facilityName = @"BBQ";
        image = [UIImage imageNamed:@"facility-bbq"];
    }*/
    
    FacilityType *type = [typeArray objectAtIndex:indexPath.row];
    NSString *facilityName = type.type;
    UIImage *image = nil;
    
    if([facilityName isEqualToString:@"Tennis Court"])
    {
        image = [UIImage imageNamed:@"facility-badminton"];
    }
    else if([facilityName isEqualToString:@"BBQ Pit"])
    {
        image = [UIImage imageNamed:@"facility-bbq"];
    }
    else if([facilityName isEqualToString:@"Function Room"])
    {
        image = [UIImage imageNamed:@"facility-multi"];
    }
    else if([facilityName isEqualToString:@"KTV Room"])
    {
        image = [UIImage imageNamed:@"facility-multi"];
    }
    
    cell.nameLabel.text = facilityName;
    cell.iconImageView.image = image;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FacilityType *type = [typeArray objectAtIndex:indexPath.row];
    
    UIStoryboard *sb = self.storyboard;
    CalendarVC *vc = [sb instantiateViewControllerWithIdentifier:@"CalendarVC"];
    vc.facilityType = type;
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
