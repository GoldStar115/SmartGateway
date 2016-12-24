//
//  WalletVC.m
//  SmartGateway
//
//  Created by Grace on 18/8/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "WalletVC.h"
#import "WebviewVC.h"

@interface WalletVC ()

@end

@implementation WalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    balanceLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)refresh
{
    if(!wallet)
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] walletOnCompletion:^(NSString *message, Wallet *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        wallet = result;
        balanceLabel.text = [NSString stringWithFormat:@"%@ %@", wallet.currency, wallet.balance];
    }
                                 onError:^(NSError* error) {
                                     [SVProgressHUD dismiss];
                                     [self showError:error onCompletion:^(UIButton *sender) {
                                         if(!wallet)
                                             [self popViewController];
                                     }];
                                 }
     ];
}

- (IBAction)topUpClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
    vc.urlString = wallet.topup_url;
    vc.title = @"Top Up";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)historyClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
    vc.urlString = wallet.history_url;
    vc.title = @"History";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)transferClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
    vc.urlString = wallet.transfer_url;
    vc.title = @"Transfer";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)purchaseClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
    vc.urlString = wallet.purchase_url;
    vc.title = @"Maintenance Fees";
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
