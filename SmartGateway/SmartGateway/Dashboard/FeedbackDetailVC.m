//
//  FeedbackDetailVC.m
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "FeedbackDetailVC.h"
#import "SubmitFeedbackVC.h"

#import "UIImageView+WebCache.h"

@interface FeedbackDetailVC ()

@end

@implementation FeedbackDetailVC

static NSString *kTypeCell = @"TypeCell";
static NSString *kVenueCell = @"VenueCell";
static NSString *kSummaryCell = @"SummaryCell";
static NSString *kFeedbackCell = @"FeedbackCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    descriptionString = @"Submitted Time:  20:00\
//    \nConfirmed Time:  21:00\
//    \nMaintenance Time:  14:00 - 15:00\
//    \nFeedback Time:  18:00";
 
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] feedbackDetail:self.feedback.id
                      onCompletion:^(NSString *message, Feedback *result) {
                          [SVProgressHUD dismiss];
                          [self showPopUp:message];
                          
                          self.feedback = result;
                          descriptionString = self.feedback.desc;
//                          headerImageView.image = [dm decodeBase64ToImage:self.feedback.image];
                          if ([self.feedback.image_urls count] > 0){
                              NSString* image_url = [self.feedback.image_urls objectAtIndex:0];
                              [headerImageView sd_setImageWithURL:[NSURL URLWithString:image_url]];
                          }
                          
                          groupedArray = [[NSMutableArray alloc] init];
                          headerArray = [[NSMutableArray alloc] init];
                          
                          NSMutableArray *array = [[NSMutableArray alloc] init];
                          [array addObject:kTypeCell];
                          [array addObject:kVenueCell];
                          [array addObject:kSummaryCell];
                          if ([self.feedback.status isEqualToString:@"completed"])
                              [array addObject:kFeedbackCell];
                          [groupedArray addObject:array];
                          [headerArray addObject:@""];
                          
                          [self.tableView reloadData];
                      }
                           onError:^(NSError* error) {
                               [SVProgressHUD dismiss];
//                               [UIAlertView showWithError:error];
                               [self showError:error onCompletion:^(UIButton *sender) {
                                   if(!self.feedback)
                                       [self popViewController];
                               }];
                           }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *)getSummaryText:(MaintenanceCell *)cell
{
    UIFont *boldFont = [UIFont fontWithName:@"Avenir-Black" size:cell.descriptionLabel.font.pointSize];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:descriptionString];
    NSArray *strArray = @[@"Submitted Time:", @"Confirmed Time:", @"Maintenance Time:", @"Feedback Time:"];
    for(NSString *str in strArray)
    {
        NSRange nameRange = [descriptionString.lowercaseString rangeOfString:str.lowercaseString];
        [string addAttribute:NSFontAttributeName value:boldFont range:nameRange];
    }
    return string;
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
    if([CellIdentifier isEqualToString:kSummaryCell])
    {
        MaintenanceCell *cell = (MaintenanceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.descriptionLabel.text = descriptionString;
//        cell.descriptionLabel.attributedText = [self getSummaryText:cell];
        return MAX(75, [cell getHeightFromScreenWidth:self.view.frame.size.width]);
    }
    if([CellIdentifier isEqualToString:kFeedbackCell])
        return 80;
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    MaintenanceCell *cell = (MaintenanceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([CellIdentifier isEqualToString:kTypeCell])
    {
        cell.descriptionLabel.text = self.feedback.item;
        cell.descriptionRightLabel.text = self.feedback.category;
    }
    else if([CellIdentifier isEqualToString:kVenueCell])
    {
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ Blk %@ Unit %@", self.feedback.condo, self.feedback.block, self.feedback.unit];
    }
    else if([CellIdentifier isEqualToString:kSummaryCell])
    {
        cell.descriptionLabel.text = descriptionString;
//        cell.descriptionLabel.attributedText = [self getSummaryText:cell];
        [cell getHeightFromScreenWidth:self.view.frame.size.width];
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
        vc.feedback = self.feedback;
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
