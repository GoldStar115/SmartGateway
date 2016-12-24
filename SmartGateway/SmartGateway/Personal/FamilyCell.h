//
//  FamilyCell.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FamilyCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *iconLabel;
@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UIButton *pendingButton;

@end
