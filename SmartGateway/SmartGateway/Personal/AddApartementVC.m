//
//  AddApartementVC.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "AddApartementVC.h"

@interface AddApartementVC ()

@end

@implementation AddApartementVC

static NSString *kApartementCell = @"ApartementCell";
static NSString *kBlockCell = @"BlockCell";
static NSString *kUnitCell = @"UnitCell";
static NSString *kAddCell = @"AddCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    addApartmentDataSource = [[AddApartmentDataSource alloc] init];
    
    cellArray = [[NSMutableArray alloc] init];
    [cellArray addObject:kApartementCell];
    [cellArray addObject:kBlockCell];
    [cellArray addObject:kUnitCell];
    [cellArray addObject:kAddCell];
    
 /*   [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] apartmentCondos:@""
                       onCompletion:^(NSString *message, NSMutableArray *result) {
                           [SVProgressHUD dismiss];
                           [self showPopUp:message];
                           condoArray = result;
                       }
                            onError:^(NSError* error) {
                                [SVProgressHUD dismiss];
//                                [UIAlertView showWithError:error];
                                [self showError:error onCompletion:^(UIButton *sender) {
                                    if(!condoArray)
                                        [self popViewController];
                                }];
                            }
     ];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)apartmentClicked:(id)sender
{
    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Apartment/Condo"
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    for(Condo *condo in condoArray)
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:condo.name
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                                     [[dm apiEngine] apartmentCondo:condo.condo_id
                                                       onCompletion:^(NSString *message, Condo *result) {
                                                           [SVProgressHUD dismiss];
                                                           [self showPopUp:message];
                                                           
                                                           selectedCondo = result;
                                                           selectedBuilding = nil;
                                                           selectedLevel = nil;
                                                           selectedUnit = nil;
                                                           
//                                                           apartmentTextfield.text = condo.name;
                                                           blockTextfield.text = @"";
                                                           levelTextfield.text = @"";
                                                           unitTextfield.text = @"";
                                                       }
                                                            onError:^(NSError* error) {
                                                                [SVProgressHUD dismiss];
//                                                                [UIAlertView showWithError:error];
                                                                [self showError:error];
                                                            }
                                      ];

                                 }];
        [actionSheet addAction:button];
    }
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
    [actionSheet addAction:cancelButton];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)blockClicked:(id)sender
{
    if(!selectedCondo)
        return;

    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Block No."
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    for(Building *building in selectedCondo.buildings)
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:building.block
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     selectedBuilding = building;
                                     selectedLevel = nil;
                                     selectedUnit = nil;
                                     
                                     blockTextfield.text = building.block;
                                     levelTextfield.text = @"";
                                     unitTextfield.text = @"";
                                 }];
        [actionSheet addAction:button];
    }
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
    [actionSheet addAction:cancelButton];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)levelClicked:(id)sender
{
    if(!selectedBuilding)
        return;
    
    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Level No."
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    for(Level *level in selectedBuilding.levels)
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:level.level
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     selectedLevel = level;
                                     selectedUnit = nil;
                                     
                                     levelTextfield.text = level.level;
                                     unitTextfield.text = @"";
                                 }];
        [actionSheet addAction:button];
    }
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
    [actionSheet addAction:cancelButton];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)unitClicked:(id)sender
{
    if(!selectedLevel)
        return;
    
    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Unit No."
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    for(Unit *unit in selectedLevel.units)
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:unit.unit_no
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     selectedUnit = unit;
                                     
                                     unitTextfield.text = unit.unit_no;
                                 }];
        [actionSheet addAction:button];
    }
    
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                   }];
    [actionSheet addAction:cancelButton];
    [self presentViewController:actionSheet animated:YES completion:nil];
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
    if([CellIdentifier isEqualToString:kAddCell])
        return 80;
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kApartementCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!apartmentTextfield)
        {
            apartmentTextfield = (MLPAutoCompleteTextField *)cell.textfield;
            apartmentTextfield.autoCompleteDataSource = addApartmentDataSource;
            [apartmentTextfield setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
            [apartmentTextfield setAutoCompleteTableBackgroundColor:[UIColor whiteColor]];
        }
        return cell;
    }
    else if([CellIdentifier isEqualToString:kBlockCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!blockTextfield)
            blockTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kUnitCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!levelTextfield)
        {
            levelTextfield = cell.textfield;
            unitTextfield = cell.textfield2;
        }
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
    if([CellIdentifier isEqualToString:kAddCell])
    {
        [self addApartment];
    }
    return nil;
}

- (void)addApartment
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] apartmentAdd:selectedUnit.unit_id
                        condo_id:selectedCondo.condo_id
                    onCompletion:^(NSString *message, bool result) {
                        [SVProgressHUD dismiss];
//                        [self showPopup];
                        if(message)
                        {
                            [self showPopUp:message onCompletion:^(UIButton *sender) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        }
                        else
                            [self.navigationController popViewControllerAnimated:YES];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ApartmentReload" object:nil];
                    }
                         onError:^(NSError* error) {
                             [SVProgressHUD dismiss];
//                             [UIAlertView showWithError:error];
                             [self showError:error];
                         }
     ];
}

- (void)showPopup
{
//    [self.navigationController popViewControllerAnimated:YES];
    UIStoryboard *sb = self.storyboard;
    PopupVC *vc = [sb instantiateViewControllerWithIdentifier:@"PopupVC"];
//    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}

#pragma mark - PopupDelegate
- (void)popup:(PopupVC *)vc didClickYes:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [vc dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)popup:(PopupVC *)vc didClickCancel:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [vc dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - MLPAutoCompleteTextField Delegate


- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    NSString *filename = [autocompleteString stringByAppendingString:@".png"];
    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    filename = [filename stringByReplacingOccurrencesOfString:@"&" withString:@"and"];
    [cell.imageView setImage:[UIImage imageNamed:filename]];
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[dm apiEngine] apartmentCondo:((AddApartmentCustomAutoCompleteObject *)selectedObject).condo.condo_id
                          onCompletion:^(NSString *message, Condo *result) {
                              [SVProgressHUD dismiss];
                              [self showPopUp:message];
                              
                              selectedCondo = result;
                              selectedBuilding = nil;
                              selectedLevel = nil;
                              selectedUnit = nil;
                              
//                              apartmentTextfield.text = condo.name;
                              blockTextfield.text = @"";
                              levelTextfield.text = @"";
                              unitTextfield.text = @"";
                          }
                               onError:^(NSError* error) {
                                   [SVProgressHUD dismiss];
//                                   [UIAlertView showWithError:error];
                                   [self showError:error];
                               }
         ];
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willHideAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view will be removed from the view hierarchy");
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view will be added to the view hierarchy");
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didHideAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view ws removed from the view hierarchy");
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didShowAutoCompleteTableView:(UITableView *)autoCompleteTableView {
    NSLog(@"Autocomplete table view was added to the view hierarchy");
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
