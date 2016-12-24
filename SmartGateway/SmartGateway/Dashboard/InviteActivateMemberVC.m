//
//  InviteActivateMemberVC.m
//  SmartGateway
//
//  Created by Grace on 13/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "InviteActivateMemberVC.h"

@interface InviteActivateMemberVC ()

@end

@implementation InviteActivateMemberVC

static NSString *kSendInvitationCell = @"SendInvitationCell";
static NSString *kActivateCell = @"ActivateCell";
static NSString *kInputInvitationCell = @"InputInvitationCell";
static NSString *kInputActivationCell = @"InputActivationCell";
static NSString *kButtonSendInviteCell = @"ButtonSendInviteCell";
static NSString *kButtonActivateCell = @"ButtonActivateCell";
static NSString *kRelationshipCell = @"RelationshipCell";
static NSString *kSectionHeader = @"SectionHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refresh];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)refresh
{
    groupedArray = [[NSMutableArray alloc] init];
    headerArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:kSendInvitationCell];
    [array addObject:kActivateCell];
    [groupedArray addObject:array];
    [headerArray addObject:@""];
    
    bool isSendInvitation = YES;
    NSIndexPath *selectedIndex = [self.tableView indexPathForSelectedRow];
    if(selectedIndex)
    {
        NSMutableArray *arr = [groupedArray objectAtIndex:selectedIndex.section];
        NSString *selectedCellID = [arr objectAtIndex:selectedIndex.row];
        if([selectedCellID isEqualToString:kSendInvitationCell])
            isSendInvitation = YES;
        else if([selectedCellID isEqualToString:kActivateCell])
            isSendInvitation = NO;
    }
    
    if(isSendInvitation)
    {
        array = [[NSMutableArray alloc] init];
        [array addObject:kInputInvitationCell];
        [array addObject:kRelationshipCell];
        [array addObject:kButtonSendInviteCell];
        [groupedArray addObject:array];
        [headerArray addObject:@"Send Invitation Code"];
    }
    else
    {
        array = [[NSMutableArray alloc] init];
        [array addObject:kInputActivationCell];
        [array addObject:kButtonActivateCell];
        [groupedArray addObject:array];
        [headerArray addObject:@"Activate Code"];
    }
    
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
    
    if([CellIdentifier isEqualToString:kInputInvitationCell] ||
       [CellIdentifier isEqualToString:kInputActivationCell])
    {
        return 130;
    }
    else if([CellIdentifier isEqualToString:kButtonSendInviteCell] ||
            [CellIdentifier isEqualToString:kButtonActivateCell] ||
            [CellIdentifier isEqualToString:kRelationshipCell])
    {
        return 80;
    }
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [groupedArray objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [arr objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kInputInvitationCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!phoneTextfield)
            phoneTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kInputActivationCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!activeCodeTextfield)
            activeCodeTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kRelationshipCell])
    {
        RelationshipCell *cell = (RelationshipCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!relationshipButton)
            relationshipButton = cell.button;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kSendInvitationCell] ||
       [CellIdentifier isEqualToString:kActivateCell])
    {
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
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
    
    if([CellIdentifier isEqualToString:kSendInvitationCell] ||
       [CellIdentifier isEqualToString:kActivateCell])
    {
        return indexPath;
    }
    
    if([CellIdentifier isEqualToString:kButtonSendInviteCell])
    {
        [self sendInvite];
    }
    else if([CellIdentifier isEqualToString:kButtonActivateCell])
    {
        [self activate];
    }
    else if([CellIdentifier isEqualToString:kRelationshipCell])
    {
        [self relatioshipClicked];
    }
    return nil;
}

- (void)relatioshipClicked
{
    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Level No."
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *relationshipArr = @[@"Father",
                                 @"Mother",
                                 @"Son",
                                 @"Daughter",
                                 @"Husband",
                                 @"Wife",
                                 @"Grandfather",
                                 @"Grandmother",
                                 @"Others",
                                 ];
    for(NSString *string in relationshipArr)
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:string
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [relationshipButton setTitle:string forState:UIControlStateNormal];
                                 }];
        [actionSheet addAction:button];
    }
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
    [actionSheet addAction:cancelButton];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)sendInvite
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] familyRegister:phoneTextfield.text
                      relationship:relationshipButton.currentTitle
                      onCompletion:^(NSString *message, bool result) {
                          [SVProgressHUD dismiss];
                          if(message)
                          {
                              [self showPopUp:message onCompletion:^(UIButton *sender) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
                          }
                          else
                              [self.navigationController popViewControllerAnimated:YES];
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"FamilyReload" object:nil];
                      }
                           onError:^(NSError* error) {
                               [SVProgressHUD dismiss];
//                               [UIAlertView showWithError:error];
                               [self showError:error];
                           }
     ];
}

- (void)activate
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] familyActivate:activeCodeTextfield.text
                      onCompletion:^(NSString *message, bool result) {
                          [SVProgressHUD dismiss];
                          if(message)
                          {
                              [self showPopUp:message onCompletion:^(UIButton *sender) {
                                  [self.navigationController popViewControllerAnimated:YES];
                              }];
                          }
                          else
                              [self.navigationController popViewControllerAnimated:YES];
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"FamilyReload" object:nil];
                      }
                           onError:^(NSError* error) {
                               [SVProgressHUD dismiss];
//                               [UIAlertView showWithError:error];
                               [self showError:error];
                           }
     ];
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
