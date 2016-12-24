//
//  LoginVC.m
//  SmartGateway
//
//  Created by Grace on 10/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "ForgotPasswordVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getLaunchData];
}

- (void)getLaunchData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] lat:@"0"
                    lng:@"0"
           onCompletion:^(NSString *message, User *result) {
               [SVProgressHUD dismiss];
               if(message)
               {
                   [self showPopUp:message onCompletion:^(UIButton *sender) {
                       if(result)
                           [self showDashboard];
                   }];
               }
               else
               {
                   if(result)
                       [self showDashboard];
               }
           }
                onError:^(NSError* error) {
                    [SVProgressHUD dismiss];
//                    [UIAlertView showWithError:error];
                    [self showError:error];
                    [dm logout];
                }
     ];
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

#pragma mark -
- (IBAction)loginClicked:(id)sender
{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] login:phoneTextfield.text
                 password:passwordTextfield.text
             onCompletion:^(NSString *message, User *result) {
                 [SVProgressHUD dismiss];
                 //        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMenu" object:nil];
//                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                 if(message)
                 {
                     [self showPopUp:message onCompletion:^(UIButton *sender) {
                         [self showDashboard];
                     }];
                 }
                 else
                     [self showDashboard];
                 passwordTextfield.text = @"";
             }
                  onError:^(NSError* error) {
                      [SVProgressHUD dismiss];
//                      [UIAlertView showWithError:error];
                      [self showError:error];
                  }
     ];
}

- (void)showDashboard
{
    UIStoryboard *sb = self.storyboard;
    UITabBarController *tabbar = [sb instantiateViewControllerWithIdentifier:@"Tabbar"];
    [self.navigationController presentViewController:tabbar animated:YES completion:nil];

}

- (IBAction)registerClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    RegisterVC *vc = [sb instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)forgetPasswordClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    ForgotPasswordVC *vc = [sb instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
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
