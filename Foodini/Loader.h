//
//  Loader.h
//  Foodini
//
//  Created by Todd Presley on 9/14/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Loader : UIView
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

+ (void)showIndicatorInParentView:(UIView *)parentView withText:(NSString *)text;

@end
