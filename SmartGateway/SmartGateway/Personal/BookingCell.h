//
//  BookingCell.h
//  SmartGateway
//
//  Created by Grace on 9/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,strong) IBOutlet UILabel *descriptionRightLabel;
@property(nonatomic,strong) IBOutlet UIButton *statusButton;
@property(nonatomic,strong) IBOutlet UIButton *makePaymentButton;

@property(nonatomic,strong) IBOutlet UIImageView *checkmarkImage;

- (void)setStatus:(NSString *)status;
- (float)getHeightFromScreenWidth:(float)screenWidth;

@end