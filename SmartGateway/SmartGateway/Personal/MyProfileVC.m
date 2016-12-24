//
//  MyProfileVC.m
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "MyProfileVC.h"

#import "UIImageView+WebCache.h"

@interface MyProfileVC ()

@end

@implementation MyProfileVC

//static NSString *kNicknameCell = @"NicknameCell";
static NSString *kFullNameCell = @"FullNameCell";
static NSString *kGenderCell = @"GenderCell";
static NSString *kMobileNoCell = @"MobileNoCell";
static NSString *kEmailCell = @"EmailCell";
static NSString *kSaveCell = @"SaveCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageChanged = NO;
    cellArray = [[NSMutableArray alloc] init];
//    [cellArray addObject:kNicknameCell];
    [cellArray addObject:kFullNameCell];
//    [cellArray addObject:kGenderCell];
    [cellArray addObject:kMobileNoCell];
    [cellArray addObject:kEmailCell];
    [cellArray addObject:kSaveCell];
    
//    if([dm cUser])
//        profileImageView.image = [dm decodeBase64ToImage:[dm cUser].image];
    [profileImageView setBackgroundColor:[UIColor whiteColor]];
    if ([dm cUser].image_url != nil && ![[dm cUser].image_url isEqualToString:@""]){
        [profileImageView sd_setImageWithURL:[NSURL URLWithString:[dm cUser].image_url]];
    }else{
        if ([dm cUser].image != nil)
            profileImageView.image = [dm decodeBase64ToImage:[dm cUser].image];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)headerClicked:(id)sender
{
    UIAlertController *actionSheet =   [UIAlertController
                                        alertControllerWithTitle:@"Change Profile Picture"
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

- (IBAction)genderClicked:(id)sender
{
    
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
    profileImageView.image = newImage;
    imageChanged = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
//    if([CellIdentifier isEqualToString:kSubmitCell])
//        return 80;
//    else if([CellIdentifier isEqualToString:kSummaryCell])
//        return 163;
//    return 90;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [cellArray objectAtIndex:indexPath.row];
    
    if([CellIdentifier isEqualToString:kFullNameCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!fullNameTextfield)
        {
            fullNameTextfield = cell.textfield;
            fullNameTextfield.text = [dm cUser].name;
        }
        return cell;
    }
    else if([CellIdentifier isEqualToString:kGenderCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!genderTextfield)
            genderTextfield = cell.textfield;
        return cell;
    }
    else if([CellIdentifier isEqualToString:kMobileNoCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!mobileNoTextfield)
        {
            mobileNoTextfield = cell.textfield;
            mobileNoTextfield.text = [dm cUser].mobile;
            mobileNoTextfield.enabled = NO;
        }
        return cell;
    }
    else if([CellIdentifier isEqualToString:kEmailCell])
    {
        InputCell *cell = (InputCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!emailTextfield)
        {
            emailTextfield = cell.textfield;
            emailTextfield.text = [dm cUser].email;
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
    if([CellIdentifier isEqualToString:kSaveCell])
        [self save];
    return nil;
}

- (void)save
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] update:[dm cUser].username
                      name:fullNameTextfield.text
                    mobile:mobileNoTextfield.text
                     image:imageChanged && profileImageView.image ? [dm encodeToBase64String:profileImageView.image] : nil
                     email:emailTextfield.text
          current_password:@""
                  password:@""
              onCompletion:^(NSString *message, bool result) {
                  [SVProgressHUD dismiss];
                  [self showPopUp:message];
                  
                  User *user = [dm cUser];
                  user.name = fullNameTextfield.text;
                  user.mobile = mobileNoTextfield.text;
                  user.email = emailTextfield.text;
                  if(imageChanged && profileImageView.image)
                      user.image = [dm encodeToBase64String:profileImageView.image];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalReload" object:nil];
                  
                  [self.navigationController popViewControllerAnimated:YES];
             }
                  onError:^(NSError* error) {
                      [SVProgressHUD dismiss];
//                      [UIAlertView showWithError:error];
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
