//
//  ViewController.m
//  SmartGateway
//
//  Created by Grace on 8/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    if(self.navigationController.viewControllers.count > 1)
    {
        [self addBackButton];
//        if(self.navigationController.viewControllers.count == 2)
//            self.hidesBottomBarWhenPushed = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackButton
{
    UIButton *menuButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 30.0f, 30.0f)];
    [menuButton setImage:[UIImage imageNamed:@"navbar-back.png"]  forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (IBAction)backClicked:(id)sender
{
    if(self.navigationController.viewControllers.count > 1)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popViewController
{
    if(self.navigationController.viewControllers.count > 1)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)showError:(NSError *)error
{
    [self showError:error onCompletion:nil];
}

- (void)showError:(NSError *)error onCompletion:(YesBlock) yesBlock
{
    if(!error)
    {
        if(yesBlock)
            yesBlock(nil);
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"%@\n\n%@",
                         [error localizedDescription]?[error localizedDescription]:@"",
                         [error localizedRecoverySuggestion]?[error localizedRecoverySuggestion]:@""];
    message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self showPopUp:message onCompletion:yesBlock onCancel:nil];
}

- (void)showPopUp:(NSString *)message
{
    [self showPopUp:message onCompletion:nil onCancel:nil];
}

- (void)showPopUp:(NSString *)message onCompletion:(YesBlock) yesBlock
{
    [self showPopUp:message onCompletion:yesBlock onCancel:nil];
}

- (void)showPopUp:(NSString *)message onCompletion:(YesBlock) yesBlock onCancel:(CancelBlock)cancelBlock
{
    if(!message || message.length == 0)
    {
        if(yesBlock)
            yesBlock(nil);
        return;
    }
    
    UIStoryboard *sb = self.storyboard;
    PopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"DepositPopupVC"];
//    vc.delegate = self;
    vc.message = message;
    vc.yesBlock = yesBlock;
    vc.cancelBlock = cancelBlock;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
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
