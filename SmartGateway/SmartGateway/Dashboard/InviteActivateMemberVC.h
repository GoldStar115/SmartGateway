//
//  InviteActivateMemberVC.h
//  SmartGateway
//
//  Created by Grace on 13/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "TableViewController.h"
#import "InviteCell.h"
#import "InputCell.h"
#import "RelationshipCell.h"

@interface InviteActivateMemberVC : TableViewController
{
    NSMutableArray *groupedArray;
    NSMutableArray *headerArray;
    
    UITextField *phoneTextfield;
    UITextField *activeCodeTextfield;
    UIButton *relationshipButton;
}

@end
