//
//  TSPRecipeDetailViewController.h
//  Foodini
//
//  Created by Todd Presley on 9/12/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSPRecipeDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitle;

@property (weak, nonatomic) NSString *titleText;
@property (weak, nonatomic) NSString *imageUrl;
@property NSArray *ingredients;
@end
