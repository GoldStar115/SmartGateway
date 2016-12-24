//
//  CALayer+XibConfiguration.m
//  LiqquidState
//
//  Created by Grace on 28/9/15.
//  Copyright (c) 2015 Grace. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end