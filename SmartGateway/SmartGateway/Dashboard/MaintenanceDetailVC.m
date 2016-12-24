//
//  MaintenanceDetailVC.m
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "MaintenanceDetailVC.h"
#import "SubmitFeedbackVC.h"

#import "UIImageView+WebCache.h"

@interface MaintenanceDetailVC ()

@end

@implementation MaintenanceDetailVC

static NSString *kItemCell = @"ItemCell";
static NSString *kApartementCell = @"ApartementCell";
static NSString *kDescriptionCell = @"DescriptionCell";
static NSString *kFeedbackCell = @"FeedbackCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] maintenanceDetail:self.maintenance.id
                         onCompletion:^(NSString *message, Maintenance *result) {
                             [SVProgressHUD dismiss];
                             [self showPopUp:message];
                             
                             self.maintenance = result;
                             descriptionString = self.maintenance.desc;
//                             headerImageView.image = [dm decodeBase64ToImage:self.maintenance.image];
                             if ([self.maintenance.image_urls count] > 0){
                                 NSString* image_url = [self.maintenance.image_urls objectAtIndex:0];
                                 [headerImageView sd_setImageWithURL:[NSURL URLWithString:image_url]];
                             }
                             
                             groupedArray = [[NSMutableArray alloc] init];
                             headerArray = [[NSMutableArray alloc] init];
                             
                             NSMutableArray *array = [[NSMutableArray alloc] init];
                             [array addObject:kItemCell];
                             [array addObject:kApartementCell];
                             [array addObject:kDescriptionCell];
                             if ([self.maintenance.status isEqualToString:@"completed"])
                                 [array addObject:kFeedbackCell];
                             [groupedArray addObject:array];
                             [headerArray addObject:@""];
                             
                             [self.tableView reloadData];
                         }
                              onError:^(NSError* error) {
                                  [SVProgressHUD dismiss];
//                                  [UIAlertView showWithError:error];
                                  [self showError:error onCompletion:^(UIButton *sender) {
                                      if(!self.maintenance)
                                          [self popViewController];
                                  }];
                              }
     ];
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
    if([CellIdentifier isEqualToString:kDescriptionCell])
    {
        BookingCell *cell = (BookingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.descriptionLabel.text = descriptionString;
//        float width = (cell.descriptionLabel.frame.size.width / 320.0) * self.view.frame.size.width;
//        float height = [dm getTextHeightFromLabel:cell.descriptionLabel width:width];
//        NSLog(@"width: %f %f screen: %f", cell.descriptionLabel.frame.size.width, width, self.view.frame.size.width);
//        NSLog(@"description height: %f [%@]", height, descriptionString);
//        return MAX(115, height+15+78);
        return MAX(115, [cell getHeightFromScreenWidth:self.view.frame.size.width]);
    }
    if([CellIdentifier isEqualToString:kFeedbackCell])
        return 80;
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    BookingCell *cell = (BookingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([CellIdentifier isEqualToString:kItemCell])
    {
        cell.descriptionLabel.text = self.maintenance.item;
        cell.descriptionRightLabel.text = self.maintenance.category;
    }
    else if([CellIdentifier isEqualToString:kApartementCell])
    {
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ Blk %@ Unit %@", self.maintenance.condo, self.maintenance.block, self.maintenance.unit];
    }
    else if([CellIdentifier isEqualToString:kDescriptionCell])
    {
        NSString *status = self.maintenance.status;
        
        cell.descriptionLabel.text = descriptionString;
        [cell getHeightFromScreenWidth:self.view.frame.size.width];
        [cell setStatus:status];
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
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    if([CellIdentifier isEqualToString:kFeedbackCell])
    {
        UIStoryboard *sb = self.storyboard;
        SubmitFeedbackVC *vc = [sb instantiateViewControllerWithIdentifier:@"SubmitFeedbackVC"];
        vc.maintenance = self.maintenance;
        [self.navigationController pushViewController:vc animated:YES];
    }

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
