//
//  ForgotPasswordCodeVC.m
//  SmartGateway
//
//  Created by Grace on 19/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ForgotPasswordCodeVC.h"

@interface ForgotPasswordCodeVC ()

@end

@implementation ForgotPasswordCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)resendCodeClicked:(id)sender
{
    
}

- (IBAction)confirmClicked:(id)sender
{
    if(codeTextfield.text.length == 0 ||
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
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] verify:self.registration_code
                phone_code:codeTextfield.text
                  username:self.username
                  password:newPasswordTextfield.text
              onCompletion:^(NSString *message, User *result) {
                  [SVProgressHUD dismiss];
                  if(message)
                  {
                      [self showPopUp:message onCompletion:^(UIButton *sender) {
                          [self.navigationController popToRootViewControllerAnimated:YES];
                      }];
                  }
                  else
                      [self.navigationController popToRootViewControllerAnimated:YES];
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
