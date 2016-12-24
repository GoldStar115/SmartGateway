//
//  CALayer+XibConfiguration.h
//  LiqquidState
//
//  Created by Grace on 28/9/15.
//  Copyright (c) 2015 Grace. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(XibConfiguration)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end