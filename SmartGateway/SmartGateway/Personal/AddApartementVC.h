//
//  AddApartementVC.h
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "PopupVC.h"
#import "InputCell.h"
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "MLPAutoCompleteTextField.h"
#import "AddApartmentDataSource.h"
#import "AddApartmentCustomAutoCompleteObject.h"

@interface AddApartementVC : TableViewController //<PopupDelegate>
{
    NSMutableArray *cellArray;
    NSMutableArray *condoArray;
    Condo *selectedCondo;
    Building *selectedBuilding;
    Level *selectedLevel;
    Unit *selectedUnit;
    AddApartmentDataSource *addApartmentDataSource;
    
//    UITextField *apartmentTextfield;
    MLPAutoCompleteTextField *apartmentTextfield;
    UITextField *blockTextfield;
    UITextField *levelTextfield;
    UITextField *unitTextfield;
}

@end
