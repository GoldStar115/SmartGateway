//
//  ApartementCell.m
//  SmartGateway
//
//  Created by Grace on 11/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "ApartementCell.h"

@implementation ApartementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.checkmarkImage.hidden = !selected;
    
    if(selected)
        self.nameLabel.textColor = [UIColor colorWithRed:40/255.0 green:167/255.0 blue:225/255.0 alpha:1];
    else
        self.nameLabel.textColor = [UIColor blackColor];
    
}

- (void)setPending:(bool)pending
{
    if(pending)
    {
        self.pendingButton.hidden = NO;
        self.checkmarkImage.hidden = YES;
    }
    else
    {
        self.pendingButton.hidden = YES;
        self.checkmarkImage.hidden = NO;
    }
}


@end
