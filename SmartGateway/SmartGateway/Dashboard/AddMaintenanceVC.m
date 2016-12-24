//
//  AddMaintenanceVC.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "AddMaintenanceVC.h"

@interface AddMaintenanceVC ()

@end

@implementation AddMaintenanceVC

static NSString *kAddPhotoCell = @"AddPhotoCell";
static NSString *kItemCell = @"ItemCell";
static NSString *kApartementCell = @"ApartementCell";
static NSString *kTypeCell = @"TypeCell";
static NSString *kBlockUnitCell = @"BlockUnitCell";
static NSString *kDescriptionCell = @"DescriptionCell";
static NSString *kSubmitCell = @"SubmitCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] maintenanceCategoryOnCompletion:^(NSString *message, NSMutableArray *result) {
        [SVProgressHUD dismiss];
        [self showPopUp:message];
        catArray = result;
    }
                                            onError:^(NSError* error) {
                                                [SVProgressHUD dismiss];
//                                                [UIAlertView showWithError:error];
                                                [self showError:error onCompletion:^(UIButton *sender) {
                                                    if(!catArray)
                                                        [self popViewController];
                                                }];
                                            }
     ];
    
    cellArray = [[NSMutableArray alloc] init];
    [cellArray addObject:kAddPhotoCell];
    [cellArray addObject:kItemCell];
    [cellArray addObject:kTypeCell];
    [cellArray addObject:kApartementCell];
//    [cellArray addObject:kBlockUnitCell];
    [cellArray addObject:kDescriptionCell];
    [cellArray addObject:kSubmitCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)typeClicked:(id)sender
{
    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Type"
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    for(MaintenanceCategory *cat in catArray)
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:cat.name
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     selectedCat = cat;
                                     typeTextfield.text = cat.name;
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
    
}

- (IBAction)addPhotoClicked:(id)sender
{
    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Add Photo"
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleActionSheet];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:kImagePickerTypeCamera
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self takeFromCamera:nil];
                                 }];
        [actionSheet addAction:button];
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertAction* button = [UIAlertAction
                                 actionWithTitle:kImagePickerTypePhotoLibrary
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self chooseFromLibrary:nil];
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

#pragma mark -
- (IBAction)takeFromCamera:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.allowsEditing = YES;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (IBAction)chooseFromLibrary:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.allowsEditing = YES;
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    float maxSize = kImageSize;
    UIImage *newImage = [dm imageWithImage:image scaleToSizeKeepAspect:CGSizeMake(maxSize, maxSize)];
    imageView.image = newImage;
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
    if([CellIdentifier isEqualToString:kSubmitCell])
        return 80;
    else if([CellIdentifier isEqualToString:kDescriptionCell])
        return 163;    
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kAddPhotoCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!imageView)
            imageView = cell.inputImageView;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kItemCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!itemTextfield)
            itemTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kTypeCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!typeTextfield)
            typeTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kApartementCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!apartmentTextfield)
        {
            apartmentTextfield = cell.textfield;
            apartmentTextfield.text = [dm cUser].default_condo;
        }
        return cell;
    }
    else if([CellIdentifier isEqualToString:kBlockUnitCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!blockUnitTextfield)
            blockUnitTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kDescriptionCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!descriptionTextView)
            descriptionTextView = cell.textview;
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
    if([CellIdentifier isEqualToString:kSubmitCell])
    {
        [self submit];
    }
    return nil;
}

- (void)submit
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] maintenanceRegister:itemTextfield.text
                            category_id:selectedCat.id
                            description:descriptionTextView.text
                                  image:imageView.image ? [dm encodeToBase64String:imageView.image] : nil
                           onCompletion:^(NSString *message, bool result) {
                               [SVProgressHUD dismiss];
                               if(message)
                               {
                                   [self showPopUp:message onCompletion:^(UIButton *sender) {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
                               }
                               else
                                   [self.navigationController popViewControllerAnimated:YES];
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"MaintenanceReload" object:nil];
                           }
                                onError:^(NSError* error) {
                                    [SVProgressHUD dismiss];
//                                    [UIAlertView showWithError:error];
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
