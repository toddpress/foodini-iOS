//
//  TSPRecipeListTableViewController.h
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSPRecipeListTableViewController : UITableViewController

//extern NSString *API_SEARCH;
//extern NSString *API_GET;
//extern NSString *API_KEY;

@property (weak, nonatomic) NSString *API_SEARCH;
@property (weak, nonatomic) NSString *API_GET;
@property (weak, nonatomic) NSString *API_KEY;

@property (weak, nonatomic) NSString *queryString;

@end
