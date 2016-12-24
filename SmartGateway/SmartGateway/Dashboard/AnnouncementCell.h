//
//  AnnouncementCell.h
//  SmartGateway
//
//  Created by Grace on 12/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncementCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *readMarkLabel;
@property(nonatomic,strong) IBOutlet UILabel *nameLabel;
@property(nonatomic,strong) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,strong) IBOutlet UILabel *dateLabel;

@end
