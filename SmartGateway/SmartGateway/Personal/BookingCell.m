//
//  BookingCell.m
//  SmartGateway
//
//  Created by Grace on 9/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "BookingCell.h"

@implementation BookingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(self.checkmarkImage)
        self.checkmarkImage.hidden = !selected;
}

- (void)setStatus:(NSString *)status
{
    UIImage *image = nil;
    UIColor *color = [UIColor clearColor];
    if(self.makePaymentButton)
        self.makePaymentButton.hidden = YES;
    
    if([status.lowercaseString isEqualToString:@"reserve"] ||
       [status.lowercaseString isEqualToString:@"reserved"])
    {
        color = [UIColor colorWithRed:247/255.0 green:148/255.0 blue:29/255.0 alpha:1.0]; //orange
        image = [UIImage imageNamed:@"status-fixing.png"];
        if(self.makePaymentButton)
            self.makePaymentButton.hidden = NO;
    }
    else if([status.lowercaseString isEqualToString:@"confirmed"] ||
            [status.lowercaseString isEqualToString:@"confirm"])
    {
        color = [UIColor colorWithRed:141/255.0 green:198/255.0 blue:63/255.0 alpha:1.0]; //green
        image = [UIImage imageNamed:@"status-confirmed.png"];
    }
    else if([status.lowercaseString isEqualToString:@"cancelled"] ||
            [status.lowercaseString isEqualToString:@"expired"])
    {
        color = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0]; //gray
        image = nil;
    }
    else if([status.lowercaseString isEqualToString:@"completed"])
    {
        color = [UIColor colorWithRed:40/255.0 green:167/255.0 blue:225/255.0 alpha:1.0]; //blue
        image = nil;
    }
    else if([status.lowercaseString isEqualToString:@"consume"])
    {
        color = [UIColor colorWithRed:244/255.0 green:154/255.0 blue:193/255.0 alpha:1.0]; //pink
        image = nil;
    }
    else if([status.lowercaseString isEqualToString:@"waiting"])
    {
        color = [UIColor colorWithRed:247/255.0 green:148/255.0 blue:29/255.0 alpha:1.0]; //orange
        image = [UIImage imageNamed:@"status-waiting.png"];
    }
    else if([status.lowercaseString isEqualToString:@"refunded"])
    {
        color = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0]; //gray
        image = [UIImage imageNamed:@"status-refunded.png"];
    }
    else if([status.lowercaseString isEqualToString:@"refunding"])
    {
        color = [UIColor colorWithRed:244/255.0 green:154/255.0 blue:193/255.0 alpha:1.0]; //pink
        image = [UIImage imageNamed:@"status-refunding.png"];
    }
    else if([status.lowercaseString isEqualToString:@"case ended"])
    {
        color = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0]; //gray
        image = nil;
    }
    else if([status.lowercaseString isEqualToString:@"booked"] /*||
            [status.lowercaseString isEqualToString:@"expired"]*/)
    {
        color = kBookingStatusFullyBookedColor;
        image = nil;
    }
    else if([status.lowercaseString isEqualToString:@"blocked"])
    {
        color = kBookingStatusFullyBlockedColor;
        image = nil;
    }
    else if(status.length > 0)
    {
        color = [UIColor grayColor];
        image = nil;
    }
    
    [self.statusButton setTitle:status.capitalizedString forState:UIControlStateNormal];
    [self.statusButton setImage:image forState:UIControlStateNormal];
    self.statusButton.backgroundColor = color;
    
}

- (float)getHeightFromScreenWidth:(float)screenWidth
{
    float width = (self.descriptionLabel.frame.size.width / 320.0) * screenWidth;
    float height = [dm getTextHeightFromLabel:self.descriptionLabel width:width];
    CGRect frame = self.descriptionLabel.frame;
    frame.size.height = height;
    self.descriptionLabel.frame = frame;
    
    return self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 15;
}

@end
