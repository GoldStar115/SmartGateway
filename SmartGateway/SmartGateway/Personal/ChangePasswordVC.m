//
//  ChangePasswordVC.m
//  SmartGateway
//
//  Created by Grace on 19/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

static NSString *kCurrentPasswordCell = @"CurrentPasswordCell";
static NSString *kNewPasswordCell = @"NewPasswordCell";
static NSString *kConfirmPasswordCell = @"ConfirmPasswordCell";
static NSString *kUpdateCell = @"UpdateCell";
static NSString *kVerificationCodeCell = @"VerificationCodeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellArray = [[NSMutableArray alloc] init];
    [cellArray addObject:kCurrentPasswordCell];
    [cellArray addObject:kNewPasswordCell];
    [cellArray addObject:kConfirmPasswordCell];
//    [cellArray addObject:kVerificationCodeCell];
    [cellArray addObject:kUpdateCell];
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
    return cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    if([CellIdentifier isEqualToString:kUpdateCell])
        return 80;
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kCurrentPasswordCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!currentPasswordTextfield)
            currentPasswordTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kNewPasswordCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!newPasswordTextfield)
            newPasswordTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kConfirmPasswordCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!confirmPasswordTextfield)
            confirmPasswordTextfield = cell.textfield;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    if([CellIdentifier isEqualToString:kUpdateCell])
        [self changePassword];
    return nil;
}

- (void)changePassword
{
    if(currentPasswordTextfield.text.length == 0 ||
       newPasswordTextfield.text.length == 0 ||
       confirmPasswordTextfield.text.length == 0 )
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Please fill out all fields"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Dismiss"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if(![newPasswordTextfield.text isEqualToString:confirmPasswordTextfield.text])
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Password not match"
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Dismiss"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] update:nil
                      name:nil
                    mobile:nil
                     image:nil
                     email:nil
          current_password:currentPasswordTextfield.text
                  password:newPasswordTextfield.text
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
              }
                   onError:^(NSError* error) {
                       [SVProgressHUD dismiss];
//                       [UIAlertView showWithError:error];
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
