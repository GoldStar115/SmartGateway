//
//  DashboardHeaderView.h
//  SmartGateway
//
//  Created by Grace on 19/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DashboardHeaderView;

@protocol DashboardHeaderDelegate <NSObject>
@optional
- (void)header:(DashboardHeaderView *)view didClickUrl:(NSString *)urlString;
@end

@interface DashboardHeaderView : UICollectionReusableView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *button;

@property (nonatomic, weak) id<DashboardHeaderDelegate> delegate;

- (void)refresh;

@end
