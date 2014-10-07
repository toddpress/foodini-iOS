//
//  IngredientCollectionViewCell.m
//  Foodini
//
//  Created by Todd Presley on 10/3/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "IngredientCollectionViewCell.h"
#import "Constants.h"

@implementation IngredientCollectionViewCell

- (void)drawRect:(CGRect)rect
{
    // inset by half line width to avoid cropping where line touches frame edges
    CGRect insetRect = CGRectInset(rect, 0.5, 0.5);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:rect.size.height/4.0];
    
    // background color
    [[UIColor clearColor] setFill];
    [path fill];
    
    // border color
    [BRAND_GREEN setStroke];
    [path stroke];
}

@end
