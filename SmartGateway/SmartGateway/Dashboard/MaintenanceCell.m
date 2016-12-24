//
//  MaintenanceCell.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "MaintenanceCell.h"

@implementation MaintenanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStatus:(NSString *)status
{
    UIImage *image;
    UIColor *color;
    float height = 22;
    if([status.lowercaseString isEqualToString:@"completed"])
    {
        color = [UIColor colorWithRed:141/255.0 green:198/255.0 blue:63/255.0 alpha:1.0]; //green
        image = [UIImage imageNamed:@"status-confirmed.png"];
    }
    else if([status.lowercaseString isEqualToString:@"rated"])
    {
        color = [UIColor colorWithRed:244/255.0 green:154/255.0 blue:193/255.0 alpha:1.0]; //pink
        image = nil;
    }
    else if([status.lowercaseString isEqualToString:@"received"])
    {
        //        color = [UIColor colorWithRed:139/255.0 green:69/255.0 blue:19/255.0 alpha:1.0]; //brown
        color = [UIColor colorWithRed:46/255.0 green:178/255.0 blue:170/255.0 alpha:1.0]; //sea green
        image = [UIImage imageNamed:@"status-confirmed.png"];
    }
    else if([status.lowercaseString isEqualToString:@"pending"])
    {
        color = [UIColor colorWithRed:46/255.0 green:178/255.0 blue:170/255.0 alpha:1.0]; //sea green
        image = [UIImage imageNamed:@"status-fixing.png"];
    }
    else if([status.lowercaseString isEqualToString:@"sent"])
    {
        color = [UIColor colorWithRed:247/255.0 green:148/255.0 blue:29/255.0 alpha:1.0]; //orange
        image = [UIImage imageNamed:@"status-fixing.png"];
    }
    else if([status.lowercaseString isEqualToString:@"done"])
    {
        color = [UIColor colorWithRed:40/255.0 green:167/255.0 blue:225/255.0 alpha:1.0]; //blue
        image = nil;
    }
    else if([status.lowercaseString isEqualToString:@"fixing in progress"])
    {
        color = [UIColor colorWithRed:247/255.0 green:148/255.0 blue:29/255.0 alpha:1.0]; //orange
        image = [UIImage imageNamed:@"status-fixing.png"];
        height = 38;
    }
    else
    {
        color = [UIColor grayColor];
    }
    
    [self.statusButton setTitle:status.capitalizedString forState:UIControlStateNormal];
    [self.statusButton setImage:image forState:UIControlStateNormal];
    self.statusButton.backgroundColor = color;
    
    CGRect frame = self.statusButton.frame;
    frame.size.height = height;
    self.statusButton.frame = frame;
}

@end
