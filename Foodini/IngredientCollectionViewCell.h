//
//  IngredientCollectionViewCell.h
//  Foodini
//
//  Created by Todd Presley on 10/3/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *removeIngredientButton;

@property (strong, nonatomic) IBOutlet UILabel *ingredientLabel;

@end
