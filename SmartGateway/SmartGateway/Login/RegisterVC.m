//
//  RegisterVC.m
//  SmartGateway
//
//  Created by Grace on 10/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "RegisterVC.h"
#import "VerificationVC.h"
#import "WebviewVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

static NSString *kNameCell = @"NameCell";
static NSString *kPhoneNumberCell = @"PhoneNumberCell";
static NSString *kPasswordCell = @"PasswordCell";
static NSString *kConfirmPasswordCell = @"ConfirmPasswordCell";
static NSString *kAgreeCell = @"AgreeCell";
static NSString *kRegisterCell = @"RegisterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellArray = [[NSMutableArray alloc] init];
    [cellArray addObject:kNameCell];
    [cellArray addObject:kPhoneNumberCell];
    [cellArray addObject:kPasswordCell];
    [cellArray addObject:kConfirmPasswordCell];
    [cellArray addObject:kAgreeCell];
    [cellArray addObject:kRegisterCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agreeClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)termsClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
    vc.urlString = [dm urls].terms_url;
    vc.title = @"Terms & Conditions";
    [self.navigationController pushViewController:vc animated:YES];
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
    if([CellIdentifier isEqualToString:kRegisterCell])
        return 80;
    else if([CellIdentifier isEqualToString:kAgreeCell])
        return 50;
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kPhoneNumberCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!phoneNumberTextfield)
            phoneNumberTextfield = cell.textfield;
        
        return cell;
    }
    else if([CellIdentifier isEqualToString:kPasswordCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!passwordTextfield)
            passwordTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kConfirmPasswordCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!confirmPasswordTextfield)
            confirmPasswordTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kNameCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!nameTextfield)
            nameTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kAgreeCell])
    {
        AgreeCell *cell = (AgreeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!agreeCheckbox)
            agreeCheckbox = cell.agreeButton;
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
    if([CellIdentifier isEqualToString:kRegisterCell])
        [self registerUser];
//        [self showVerificationView];
    return nil;
}

- (void)registerUser
{
    if(phoneNumberTextfield.text.length == 0 ||
       passwordTextfield.text.length == 0 ||
       confirmPasswordTextfield.text.length == 0 ||
       nameTextfield.text.length == 0)
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
    
    if(![passwordTextfield.text isEqualToString:confirmPasswordTextfield.text])
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Password does not match"
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
    
    if(!agreeCheckbox.selected)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"You must read and agree to the Terms & Conditions"
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
    [[dm apiEngine] registerUsername:phoneNumberTextfield.text
                              mobile:phoneNumberTextfield.text
                               email:@""
                                name:nameTextfield.text
                            password:passwordTextfield.text
                        onCompletion:^(NSString *message, NSString *result) {
                            [SVProgressHUD dismiss];
                            //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMenu" object:nil];
                            if(message)
                            {
                                [self showPopUp:message onCompletion:^(UIButton *sender) {
                                    [self showVerificationView:result];
                                }];
                            }
                            else
                                [self showVerificationView:result];
                        }
                             onError:^(NSError* error) {
                                 [SVProgressHUD dismiss];
//                                 [UIAlertView showWithError:error];
                                 [self showError:error];
                             }
     ];
}

- (void)showVerificationView:(NSString *)registration_code
{
    UIStoryboard *sb = self.storyboard;
    VerificationVC *vc = [sb instantiateViewControllerWithIdentifier:@"VerificationVC"];
    vc.registration_code = registration_code;
    vc.phoneNumber = [NSString stringWithFormat:@"+65 %@", phoneNumberTextfield.text];
    [self.navigationController pushViewController:vc animated:YES];
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
