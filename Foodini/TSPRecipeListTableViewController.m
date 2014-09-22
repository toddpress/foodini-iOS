//
//  TSPRecipeListTableViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//
#import "Constants.h"
#import "TSPRecipeListTableViewController.h"
#import "TSPRecipeCellTableViewCell.h"
#import "TSPRecipeDetailViewController.h"
#import "TSPShortRecipe.h"


@interface TSPRecipeListTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;

@end


@implementation TSPRecipeListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recipesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TSPRecipeCellTableViewCell *cell = (TSPRecipeCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"recipeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TSPRecipeCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recipeCell"];
    }
    TSPShortRecipe *recipe = [_recipesArray objectAtIndex:indexPath.row];
    cell.recipeTitle.text = recipe.title;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //fetch the image data from the url
        NSURL *imgURL = [NSURL URLWithString:recipe.image_url];
        NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
        
        //start a UI thread for what we need to update on the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //set the image
            cell.recipeImage.image = [UIImage imageWithData:imageData];
        });
    });
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SegueToDetail"]){
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        TSPShortRecipe *selectedRecipe = [_recipesArray objectAtIndex:indexPath.row];
        TSPRecipeDetailViewController *detailController = segue.destinationViewController;
        
        detailController.titleText = selectedRecipe.title;
        detailController.imageUrl = selectedRecipe.image_url;
        detailController.recipeUrl = selectedRecipe.recipe_url;

        NSError *error;
        NSString *strURL = [NSString stringWithFormat:@"%@%@&rId=%@", API_GET, API_KEY, selectedRecipe.recipe_id];
        NSURL *url = [NSURL URLWithString:strURL];
        NSData* data = [[NSData alloc ] initWithContentsOfURL: url];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSDictionary *recipe = json[@"recipe"];
        
        
        detailController.ingredients = recipe[@"ingredients"];
    }
    
}

@end
