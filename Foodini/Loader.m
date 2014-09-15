//
//  Loader.m
//  Foodini
//
//  Created by Todd Presley on 9/14/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "Loader.h"

@implementation Loader

@synthesize textLabel;
@synthesize indicator;

float const LoaderWidth = 226.0f;
float const LoaderHeight = 112.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init code...
    }
    return self;
}

-(void)setTextLabel:(UILabel *)theTextLabel
{
    textLabel = theTextLabel;
    [self addSubview:theTextLabel];
}

+ (void)showIndicatorInParentView:(UIView *)parentView withText:(NSString *)text
{
    for (UIView *subView in [parentView subviews]) {
        if([subView isKindOfClass:[Loader class]])
        {
            NSLog(@"%@", @"Something's up; there's already a loader here.");
            return;
        }
    }
    
    CGRect selfFrame = CGRectMake(parentView.bounds.size.width/2 - LoaderWidth/2, parentView.bounds.size.height/2 - LoaderHeight/2, LoaderWidth, LoaderHeight);
    
    Loader *loader = [[Loader alloc] initWithFrame:selfFrame];
    loader.backgroundColor = [UIColor blackColor];
    loader.alpha = 0.0f;
    loader.layer.cornerRadius = 4.0;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(LoaderWidth/2, 28.0+9.5);
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0, loader.frame.size.height/2 - 56.0+20, loader.frame.size.width - 16.0, 112.0)];
    
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor  whiteColor];
    textLabel.numberOfLines = 0;
    textLabel.font = [UIFont systemFontOfSize:17.0];
    textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    textLabel.text = text;
    
    [loader setTextLabel:textLabel];

    [loader addSubview:indicator];
    [parentView addSubview:loader];
    [indicator startAnimating];
    
    [UIView animateWithDuration:0.4 animations:^ {
        loader.alpha = 0.9f;
        loader.textLabel.alpha = 0.9f;
    }completion:^(BOOL finished) {
        if(finished) {
        
        }
    }];
}

-(void)hideSelf
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
        self.textLabel.alpha = 0.0;
    }completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
