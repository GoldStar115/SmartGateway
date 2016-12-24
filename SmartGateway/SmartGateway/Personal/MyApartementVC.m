//
//  MyApartementVC.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "MyApartementVC.h"
#import "AddApartementVC.h"

@interface MyApartementVC ()

@end

@implementation MyApartementVC
NSIndexPath *selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"ApartmentReload" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"PersonalReload" object:nil];
    [self refresh];
}

- (void)refresh
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] apartmentListOnCompletion:^(NSString *message, NSMutableArray *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        
        apartments = result;
        [self.tableView reloadData];
        
        selectedIndex = nil;
        if([dm cUser].default_condo && [dm cUser].default_condo.length > 0)
        {
            int index = 0;
            for(Apartment *apartment in apartments)
            {
//                if([apartment.condo.name isEqualToString:[dm cUser].default_condo])
                if(apartment.apartment_default.boolValue == YES)
                {
                    selectedIndex = [NSIndexPath indexPathForRow:index inSection:0];
                    [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
                    break;
                }
                
                index ++;
            }
        }
    }
                                      onError:^(NSError* error) {
                                          [SVProgressHUD dismiss];
//                                          [UIAlertView showWithError:error];
                                          [self showError:error onCompletion:^(UIButton *sender) {
                                              if(!apartments)
                                                  [self popViewController];
                                          }];
                                      }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addClicked:(id)sender
{
    UIStoryboard *sb = self.storyboard;
    AddApartementVC *vc = [sb instantiateViewControllerWithIdentifier:@"AddApartementVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return apartments.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 65;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ApartementCell";
    ApartementCell *cell = (ApartementCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    NSString *name = @"Seahill";
//    NSString *type = @"Condo";
//    NSString *block = @"4";
//    NSString *unit = @"5A";
//    bool isPending = YES;
//    
//    if(indexPath.row == 0)
//    {
//        name = @"D’Hillside Loft";
//        type = @"Condo";
//        block = @"14";
//        unit = @"7c";
//        isPending = NO;
//    }
    
    Apartment *apartment = [apartments objectAtIndex:indexPath.row];
    NSString *name = apartment.condo.name;
    NSString *type = @"Condo";
    NSString *block = apartment.condo.building.block;
    NSString *unit = apartment.condo.building.level.unit.unit_no;
    bool isPending = [apartment.status isEqualToString:@"pending"] ? YES : NO;
    
    cell.nameLabel.text = name;
    cell.typeLabel.text = [NSString stringWithFormat:@"Type: %@", type];
    cell.blockLabel.text = [NSString stringWithFormat:@"Block: %@       Unit: %@", block, unit];
    [cell setPending:isPending];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:[NSString stringWithFormat:@"Are you sure you want to switch apartment?"]
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   Apartment *apartment = [apartments objectAtIndex:indexPath.row];
                                   [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                                   [[dm apiEngine] apartmentSwitch:apartment.apartment_id
                                                      onCompletion:^(NSString *message, bool result) {
                                                          [SVProgressHUD dismiss];
                                                          [self showPopUp:message];
                                                          [dm cUser].default_condo = apartment.condo.name;
                                                          [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalReload" object:nil];
                                                      }
                                                           onError:^(NSError* error) {
                                                               [SVProgressHUD dismiss];
                                                               //[UIAlertView showWithError:error];
                                                               [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                                               [self showError:error];
                                                           }
                                    ];
                               }];
    UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
    

//    return indexPath;
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        Apartment *apartment = [apartments objectAtIndex:indexPath.row];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[dm apiEngine] apartmentRemove:apartment.apartment_id
                           onCompletion:^(NSString *message, bool result) {
                               [SVProgressHUD dismiss];
                               [self showPopUp:message];
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"ApartmentReload" object:nil];
                           }
                                onError:^(NSError* error) {
                                    [SVProgressHUD dismiss];
//                                    [UIAlertView showWithError:error];
                                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                                    [self showError:error];
                                }
         ];
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndex)
        [self.tableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
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
