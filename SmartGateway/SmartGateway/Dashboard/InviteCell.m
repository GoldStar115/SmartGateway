//
//  InviteCell.m
//  SmartGateway
//
//  Created by Grace on 13/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "InviteCell.h"

@implementation InviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.checkmark.hidden = !selected;
//    self.iconLabel.textColor = selected ? self.iconLabel.highlightedTextColor : [UIColor blackColor];
//    self.nameLabel.textColor = selected ? self.nameLabel.highlightedTextColor : [UIColor blackColor];
    self.iconLabel.highlighted = selected;
    self.nameLabel.highlighted = selected;
}

@end
