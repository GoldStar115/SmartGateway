//
//  FeedbackVC.m
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "FeedbackVC.h"
#import "AddFeedbackVC.h"
#import "FeedbackDetailVC.h"

@interface FeedbackVC ()

@end

@implementation FeedbackVC

static NSString *kFeedbackCell = @"FeedbackCell";
static NSString *kDescriptionCell = @"DescriptionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"FeedbackReload" object:nil];
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] feedbackListOnCompletion:^(NSString *message, NSMutableArray *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        feedbackArray = result;
        [self.tableView reloadData];
    }
                                        onError:^(NSError* error) {
                                            [SVProgressHUD dismiss];
//                                            [UIAlertView showWithError:error];
                                            [self showError:error onCompletion:^(UIButton *sender) {
                                                if(!feedbackArray)
                                                    [self popViewController];
                                            }];
                                        }
     ];

//    groupedArray = [[NSMutableArray alloc] init];
//    headerArray = [[NSMutableArray alloc] init];
//    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    [array addObject:kFeedbackCell];
//    [array addObject:kDescriptionCell];
//    [groupedArray addObject:array];
//    [headerArray addObject:@""];
//    
//    array = [[NSMutableArray alloc] init];
//    [array addObject:kFeedbackCell];
//    [groupedArray addObject:array];
//    [headerArray addObject:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    AddFeedbackVC *vc = [sb instantiateViewControllerWithIdentifier:@"AddFeedbackVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return headerArray.count;
    return feedbackArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSMutableArray *arr = [groupedArray objectAtIndex:section];
//    return arr.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if(((NSString *)[headerArray objectAtIndex:section]).length == 0)
//        return 0;
//    return 18;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
//    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
//    if([CellIdentifier isEqualToString:kDescriptionCell])
    if(indexPath.row > 0) //description
        return 70;
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    FeedbackCell *cell = (FeedbackCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if([CellIdentifier isEqualToString:kFeedbackCell])
    {
        NSString *dateString = @"22 Feb 2016";
        NSString *type = @"Light Fuse Blown";
        NSString *apartement = @"D’Hillside Loft Condo";
        NSString *status = @"Case Ended";
        
        if(indexPath.section == 0)
        {
            dateString = @"24 Feb 2016";
            type = @"Tap Leaking";
            apartement = @"D’Hillside Loft Condo";
            status = @"Waiting";
        }
        
        cell.nameLabel.text = dateString;
        cell.descriptionLabel.text = [NSString stringWithFormat:@"Type: %@\n%@", type, apartement];
        [cell setStatus:status];
    }
    else if([CellIdentifier isEqualToString:kDescriptionCell])
    {
        cell.descriptionLabel.text = @"My kitchen sink tap has been leaking for 2 days. I tried to tighten the grip, but it has been helpful. I have no idea what is the main problem that is causing the leaking, it will be very much appreciated if you can attend to it asap.";
    }
    
    return cell;*/
    
    Feedback *feedback = [feedbackArray objectAtIndex:indexPath.section];
    if(indexPath.row == 0)
    {
        FeedbackCell *cell = (FeedbackCell *)[tableView dequeueReusableCellWithIdentifier:kFeedbackCell];
        
        NSDate *date = [[dm serverDateLongFormatter] dateFromString:feedback.date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMM yyyy"];
        
        NSString *dateString = [df stringFromDate:date];
        NSString *type = feedback.item;
        NSString *apartement = feedback.condo;
        NSString *status = feedback.status;
        
        cell.nameLabel.text = dateString;
        cell.descriptionLabel.text = [NSString stringWithFormat:@"Subject: %@\n%@", type, apartement];
        [cell setStatus:status];
        return cell;
    }
    else
    {
        FeedbackCell *cell = (FeedbackCell *)[tableView dequeueReusableCellWithIdentifier:kDescriptionCell];
        cell.descriptionLabel.text = feedback.desc;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        Feedback *feedback = [feedbackArray objectAtIndex:indexPath.section];
    
        UIStoryboard *sb = self.storyboard;
        FeedbackDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"FeedbackDetailVC"];
        vc.feedback = feedback;
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
