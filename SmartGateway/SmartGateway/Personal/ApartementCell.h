//
//  ApartementCell.h
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApartementCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UILabel *typeLabel;
@property(nonatomic,strong) IBOutlet UILabel *blockLabel;
@property(nonatomic,strong) IBOutlet UIButton *pendingButton;
@property(nonatomic,strong) IBOutlet UIImageView *checkmarkImage;

- (void)setPending:(bool)pending;

@end
