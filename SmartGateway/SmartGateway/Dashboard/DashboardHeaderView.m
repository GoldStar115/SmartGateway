//
//  DashboardHeaderView.m
//  SmartGateway
//
//  Created by Grace on 19/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "DashboardHeaderView.h"
#import "UIButton+WebCache.h"

@implementation DashboardHeaderView

- (void)refresh
{
    NSMutableArray *banners = [dm banners];
    self.pageControl.numberOfPages = banners.count;
    
    if (self.pageControl.numberOfPages > 1){
        self.pageControl.hidden = NO;
    }else{
        self.pageControl.hidden = YES;
    }
    
    for(UIView *vw in self.scrollView.subviews)
    {
        if(vw != self.button)
            [vw removeFromSuperview];
    }
    
    int index = 0;
    for(Banner *banner in banners)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if(index == 0)
        {
            button = self.button;
            [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        }
        else
        {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.autoresizingMask = self.button.autoresizingMask;
            [self.scrollView addSubview:button];
        }
        
        CGRect frame = self.button.frame;
        frame.origin.x = frame.size.width * index;
        button.frame = frame;
        button.tag = index;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
//        [button setImage:[dm decodeBase64ToImage:banner.image] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        if (banner.url != nil){
            [button sd_setImageWithURL:[NSURL URLWithString:banner.url] forState:UIControlStateNormal];
        }
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        index ++;
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.button.frame.size.width * banners.count, self.scrollView.frame.size.height)];
}

- (IBAction)buttonClicked:(UIButton *)sender
{
    if(self.delegate)
    {
        Banner *banner = [[dm banners] objectAtIndex:sender.tag];
        [self.delegate header:self didClickUrl:banner.url];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
}

@end
