//
//  TSPRecipeDetailViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/12/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPRecipeDetailViewController.h"
#import "TSPIngredientCell.h"

@interface TSPRecipeDetailViewController ()

@end

@implementation TSPRecipeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.recipeTitle.text = self.titleText;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *imgURL = [NSURL URLWithString:self.imageUrl];
        NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipeImage.image = [UIImage imageWithData:imgData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ingredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ingredient = [self.ingredients objectAtIndex:indexPath.row];
    
    TSPIngredientCell *cell = (TSPIngredientCell *) [tableView dequeueReusableCellWithIdentifier:@"ingredientCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TSPIngredientCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ingredientCell"];
    }
    
    cell.ingredientLabel.text = ingredient;
    return cell;
}

@end
