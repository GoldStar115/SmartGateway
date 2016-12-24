//
//  VerificationVC.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "VerificationVC.h"
#import "WelcomeVC.h"

@interface VerificationVC ()

@end

@implementation VerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    phoneLabel.text = self.phoneNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterClicked:(id)sender
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] verify:self.registration_code
                phone_code:codeTextfield.text
                  username:@""
                  password:@""
              onCompletion:^(NSString *message, User *result) {
                  [SVProgressHUD dismiss];
                  if(message)
                  {
                      [self showPopUp:message onCompletion:^(UIButton *sender) {
                          [self showWelcomeView];
                      }];
                  }
                  else
                      [self showWelcomeView];
              }
                   onError:^(NSError* error) {
                       [SVProgressHUD dismiss];
//                       [UIAlertView showWithError:error];
                       [self showError:error];
                   }
     ];
}

- (IBAction)resendCodeClicked:(id)sender
{
    
}

- (void)showWelcomeView
{
    UIStoryboard *sb = self.storyboard;
    WelcomeVC *vc = [sb instantiateViewControllerWithIdentifier:@"WelcomeVC"];
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
