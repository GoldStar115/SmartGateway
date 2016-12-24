//
//  SubmitFeedbackVC.m
//  SmartGateway
//
//  Created by Grace on 13/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "SubmitFeedbackVC.h"

@interface SubmitFeedbackVC ()

@end

@implementation SubmitFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)starClicked:(UIButton *)sender
{
    int index = (int)sender.tag;
    star1.selected = index >= 1;
    star2.selected = index >= 2;
    star3.selected = index >= 3;
    star4.selected = index >= 4;
    star5.selected = index >= 5;
}

- (IBAction)submitClicked:(id)sender
{
    if(self.feedback)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[dm apiEngine] feedbackRate:self.feedback.id
                                rate:[self getRateString]
                             comment:textview.text
                        onCompletion:^(NSString *message, bool result) {
                            [self showPopUp:message onCompletion:^(UIButton *sender) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"FeedbackReload" object:nil];
                            
                        }
                             onError:^(NSError* error) {
                                 [SVProgressHUD dismiss];
//                                 [UIAlertView showWithError:error];
                                 [self showError:error];
                             }
         ];
    }
    else if(self.maintenance)
    {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[dm apiEngine] maintenanceRate:self.maintenance.id
                                   rate:[self getRateString]
                                comment:textview.text
                           onCompletion:^(NSString *message, bool result) {
                               [self showPopUp:message onCompletion:^(UIButton *sender) {
                                   [self.navigationController popToRootViewControllerAnimated:YES];
                               }];
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"MaintenanceReload" object:nil];
                               
                           }
                                onError:^(NSError* error) {
                                    [SVProgressHUD dismiss];
//                                    [UIAlertView showWithError:error];
                                    [self showError:error];
                                }
         ];
    }
}

- (NSString *)getRateString
{
    if(star5.selected)
        return @"excellent";
    else if(star4.selected)
        return @"very_good";
    else if(star3.selected)
        return @"good";
    else if(star2.selected)
        return @"fair";
    else //if(star1.selected)
        return @"poor";
    
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
