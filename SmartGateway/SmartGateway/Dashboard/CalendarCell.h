//
//  CalendarCell.h
//  SmartGateway
//
//  Created by Grace on 14/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property(nonatomic,strong) IBOutlet UILabel *dateLabel;
@property(nonatomic,strong) IBOutlet UIView *statusView;

- (void)setStatus:(NSString *)status;

@end
