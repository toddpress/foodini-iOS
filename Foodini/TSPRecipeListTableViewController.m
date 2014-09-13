//
//  TSPRecipeListTableViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPRecipeListTableViewController.h"
#import "TSPRecipeCellTableViewCell.h"
#import "TSPRecipeDetailViewController.h"
#import "TSPShortRecipe.h"

@interface TSPRecipeListTableViewController ()
@property NSMutableArray *aRecipes;
@end


@implementation TSPRecipeListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.API_KEY = @"0051927f71d94e11d2dcdda167b4559c";
    self.API_SEARCH = @"http://food2fork.com/api/search?key=";
    self.API_GET = @"http://food2fork.com/api/get?key=";
    [self getShortRecipes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    //show loader view
//    [HUD showUIBlockingIndicatorWithText:@"Fetching JSON"];
//}

#pragma mark - JSON loading

- (void)getShortRecipes {
    self.aRecipes = [[NSMutableArray alloc] init];
    NSError *error;
    NSString *strURL = [NSString stringWithFormat:@"%@%@&q=%@", self.API_SEARCH, self.API_KEY, self.queryString];
    NSURL *url = [NSURL URLWithString:strURL];
    NSData* data = [[NSData alloc ] initWithContentsOfURL: url];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    for (NSDictionary *recipe in json[@"recipes"]) {
        TSPShortRecipe *recipeObject = [[TSPShortRecipe alloc] init];
        recipeObject.title = recipe[@"title"];
        recipeObject.image_url = recipe[@"image_url"];
        recipeObject.recipe_id = recipe[@"recipe_id"];
        [self.aRecipes addObject:recipeObject];
        NSLog(@"RECIPE: %@", recipeObject);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.aRecipes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TSPRecipeCellTableViewCell *cell = (TSPRecipeCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"recipeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TSPRecipeCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recipeCell"];
    }
    TSPShortRecipe *recipe = [self.aRecipes objectAtIndex:indexPath.row];
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
        TSPShortRecipe *selectedRecipe = [self.aRecipes objectAtIndex:indexPath.row];
        TSPRecipeDetailViewController *detailController = segue.destinationViewController;
        
        detailController.titleText = selectedRecipe.title;
        detailController.imageUrl = selectedRecipe.image_url;
        
        NSError *error;
        NSString *strURL = [NSString stringWithFormat:@"%@%@&rId=%@", self.API_GET, self.API_KEY, selectedRecipe.recipe_id];
        NSURL *url = [NSURL URLWithString:strURL];
        NSData* data = [[NSData alloc ] initWithContentsOfURL: url];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSDictionary *recipe = json[@"recipe"];
        detailController.ingredients = recipe[@"ingredients"];
    }
    
}
//#pragma mark - Table view delegate



@end
