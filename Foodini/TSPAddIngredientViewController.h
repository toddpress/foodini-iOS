//
//  TSPAddIngredientViewController.h
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSPAddIngredientViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *AddIngredientTable;

@property (weak, nonatomic) IBOutlet UITextField *AddIngredientTextField;

@end
