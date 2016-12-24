//
//  MyFamilyVC.m
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "MyFamilyVC.h"
#import "InviteActivateMemberVC.h"

@interface MyFamilyVC ()

@end

@implementation MyFamilyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    cellArray = [[NSMutableArray alloc] init];
//    [cellArray addObject:@"Kim Xin Ting (Wife)"];
//    [cellArray addObject:@"Halsey Khoo (Daughter)"];
//    [cellArray addObject:@"Jeslie Khoo (Daughter)"];
 
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"FamilyReload" object:nil];
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] familyListOnCompletion:^(NSString *message, NSMutableArray *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        familyArray = result;
        [self.tableView reloadData];
    }
                                   onError:^(NSError* error) {
                                       [SVProgressHUD dismiss];
//                                       [UIAlertView showWithError:error];
                                       [self showError:error onCompletion:^(UIButton *sender) {
                                           if(!familyArray)
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
    InviteActivateMemberVC *vc = [sb instantiateViewControllerWithIdentifier:@"InviteActivateMemberVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return familyArray.count;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"FamilyCell";
    
    Family *family = [familyArray objectAtIndex:indexPath.row];
    NSString *name = family.name;
    FamilyCell *cell = (FamilyCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.nameLabel.text = name;
    if(family.relationship && family.relationship.length > 0)
        cell.nameLabel.text = [cell.nameLabel.text stringByAppendingFormat:@" (%@)", family.relationship];
    cell.pendingButton.hidden = !family.pending;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *name = [cellArray objectAtIndex:indexPath.row];
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
                                      alertControllerWithTitle:[NSString stringWithFormat:@"Are you sure you want to remove this member?"]
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        Family *family = [familyArray objectAtIndex:indexPath.row];
                                        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                                        [[dm apiEngine] familyRemove:family.user_id
                                                             pending:family.pending
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
