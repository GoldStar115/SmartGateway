//
//  AnnouncementVC.m
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "AnnouncementVC.h"

#import "WebviewVC.h"

@interface AnnouncementVC ()

@end

@implementation AnnouncementVC

static NSString *kAnnouncementCell = @"AnnouncementCell";
static NSString *kSectionHeader = @"SectionHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] announcementOnCompletion:^(NSString *message, Announcement *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        announcement = result;
        [self reload];
    }
                                     onError:^(NSError* error) {
                                         [SVProgressHUD dismiss];
//                                         [UIAlertView showWithError:error];
                                         [self showError:error onCompletion:^(UIButton *sender) {
                                             if(!announcement)
                                                 [self popViewController];
                                         }];

                                     }
     ];
}

- (void)reload
{
    groupedArray = [[NSMutableArray alloc] init];
    headerArray = [[NSMutableArray alloc] init];
    
    if(announcement)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
//        [array addObject:kAnnouncementCell];
//        [array addObject:kAnnouncementCell];
        if(condoButton.selected)
        {
            [array addObjectsFromArray:announcement.condo];
            [headerArray addObject:@"Condo"];
        }
        else
        {
            [array addObjectsFromArray:announcement.system];
            [headerArray addObject:@"System"];
        }
        [groupedArray addObject:array];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)condoClicked:(id)sender
{
    condoButton.selected = YES;
    systemButton.selected = NO;
    [self reload];
}

- (IBAction)systemClicked:(id)sender
{
    condoButton.selected = NO;
    systemButton.selected = YES;
    [self reload];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = kAnnouncementCell;
    AnnouncementCell *cell = (AnnouncementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    SystemMessage *sMessage = [arr objectAtIndex:indexPath.row];

    NSDate *date = [[dm serverDateLongFormatter] dateFromString:sMessage.create_date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy"];
    
    NSString *name = sMessage.subject;
    NSString *dateString = [df stringFromDate:date];
    NSString *description = sMessage.content;
    
    
//    NSString *name = @"Diredrill";
//    NSString *date = @"21 Feb 2016";
//    NSString *description = @"D’hillside Loft Condominium will be having bi-annual firedrill event for its residents on 22 Feb 2016. All ...";
//    
//    if(condoButton.selected)
//    {
//        if(indexPath.row == 0)
//        {
//            name = @"Fun-Fair Date";
//            date = @"24 Feb 2016";
//            description = @"Seahill Condominium will be having its annual fun fair event for its residents from 13 March to 20 March ...";
//        }
//    }
//    else
//    {
//        if(indexPath.row == 0)
//        {
//            name = @"Maintenance";
//            date = @"24 Feb 2016";
//            description = @"We will be having maintenance scheduled from 12am to 4am on 25 Feb 2016. We regret to inform that ...";
//        }
//        else if(indexPath.row == 1)
//        {
//            name = @"Maintenance";
//            date = @"24 Feb 2016";
//            description = @"We will be having an urgent maintenance scheduled from 9am to 10am today. We regret to inform that ...";
//        }
//    }
    
    cell.nameLabel.text = name;
    cell.dateLabel.text = dateString;
    cell.descriptionLabel.text = description;
    cell.readMarkLabel.hidden = [sMessage.status isEqualToString:@"notread"] ? NO : YES;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    SystemMessage *sMessage = [arr objectAtIndex:indexPath.row];
    
    NSString* urlString = @"";
    
    if (condoButton.selected == YES){
        urlString = [NSString stringWithFormat:@"https://%@/announcement/detail/?condo_bid=%@", [dm apiEngine].readonlyHostName, sMessage.id];
    }else{
        urlString = [NSString stringWithFormat:@"https://%@/announcement/detail/?system_bid=%@", [dm apiEngine].readonlyHostName, sMessage.id];
    }
    
    UIStoryboard *sb = self.storyboard;
    WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
    vc.urlString = urlString;
    vc.title = sMessage.subject;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
