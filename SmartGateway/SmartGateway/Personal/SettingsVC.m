//
//  SettingsVC.m
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "SettingsVC.h"
#import "ChangePasswordVC.h"
#import "WebviewVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

static NSString *kNotificationSound = @"Notification Sound";
static NSString *kChangePassword = @"Change Password";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    cellArray = [[NSMutableArray alloc] init];
    [cellArray addObject:kNotificationSound];
    [cellArray addObject:kChangePassword];
    [cellArray addObject:@"Privacy Policy"];
    [cellArray addObject:@"Terms of Use"];
    
    soundOn = YES;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"SettingsCell";
    SettingsCell *cell = (SettingsCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSString *menuName = [cellArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = menuName;
    if([menuName isEqualToString:kNotificationSound])
        cell.checkmarkImage.hidden = !soundOn;
    else
        cell.checkmarkImage.hidden = YES;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    if([CellIdentifier isEqualToString:kNotificationSound])
    {
        soundOn = !soundOn;
        [self.tableView reloadData];
    }
    else if([CellIdentifier isEqualToString:kChangePassword])
    {
        UIStoryboard *sb = self.storyboard;
        ChangePasswordVC *vc = [sb instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([CellIdentifier isEqualToString:@"Privacy Policy"])
    {
        UIStoryboard *sb = self.storyboard;
        WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
        vc.urlString = [dm urls].privacy_url;
        vc.title = CellIdentifier;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([CellIdentifier isEqualToString:@"Terms of Use"])
    {
        UIStoryboard *sb = self.storyboard;
        WebviewVC *vc = [sb instantiateViewControllerWithIdentifier:@"WebviewVC"];
        vc.urlString = [dm urls].terms_url;
        vc.title = CellIdentifier;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return nil;
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
