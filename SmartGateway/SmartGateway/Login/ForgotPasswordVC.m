//
//  ForgotPasswordVC.m
//  SmartGateway
//
//  Created by Grace on 19/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "ForgotPasswordCodeVC.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

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

- (IBAction)nextClicked:(id)sender
{
    
    NSString* phoneNumber = phoneTextfield.text;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] forgot:phoneNumber
              onCompletion:^(NSString *message, NSString *result) {
                  [SVProgressHUD dismiss];
                  if(message)
                  {
                      [self showPopUp:message onCompletion:^(UIButton *sender) {
                          [self showForgotPasswordCode:result];
                      }];
                  }
                  else
                      [self showForgotPasswordCode:result];
              }
                   onError:^(NSError* error) {
                       [SVProgressHUD dismiss];
//                       [UIAlertView showWithError:error];
                       [self showError:error onCompletion:^(UIButton *sender) {
                       }];
                   }
     ];
}

- (void)showForgotPasswordCode:(NSString *)registration_code
{
    UIStoryboard *sb = self.storyboard;
    ForgotPasswordCodeVC *vc = [sb instantiateViewControllerWithIdentifier:@"ForgotPasswordCodeVC"];
    vc.registration_code = registration_code;
    vc.username = phoneTextfield.text;
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
