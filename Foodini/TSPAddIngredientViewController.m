//
//  TSPAddIngredientViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//
#import <objc/runtime.h>
#import "Constants.h"
#import "TSPAddIngredientViewController.h"
#import "IngredientCollectionViewCell.h"

#import "TSPRecipeListTableViewController.h"

#import "TSPShortRecipe.h"
#import "ToastView.h"


@interface TSPAddIngredientViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchRecipesButton;

@property NSMutableArray *ingredientsArray;
@property NSArray *recipesArray;

@property UINavigationBar *bar;
@property UIView *navBorder;
@property UIBarButtonItem *leftButton;

@end

@implementation TSPAddIngredientViewController {
    IngredientCollectionViewCell *sizingCell;
}
// TODO eliminate any unneeded NSOperationQueues
// TODO move navigation bar stuff
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // collection
    
    UINib *cellNib = [UINib nibWithNibName:@"IngredientViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ItemView"];
    sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    //
    // Navigation Bar Styling, etc
    //

    _bar = self.navigationController.navigationBar;
    _bar.barTintColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.24 alpha:0.75];
    _bar.tintColor = BRAND_RED;
    _bar.translucent = YES;
    
    // logo
    _leftButton = self.navigationItem.leftBarButtonItem;
    _leftButton.enabled = NO;
    NSDictionary *leftButtonAppearance = @{NSFontAttributeName: [UIFont fontWithName:@"Elephont-Light" size:26.0],
                                           NSForegroundColorAttributeName: BRAND_RED};
    
    [_leftButton setTitleTextAttributes:leftButtonAppearance forState:UIControlStateNormal];
    // bottom border
    
    _navBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.bar.frame.size.height-1, self.bar.frame.size.width, 1)];
    UIView *border = _navBorder;
    [border setBackgroundColor:BRAND_GREEN];
    [border setOpaque:YES];
    [self.bar addSubview:border];
    
    _ingredientsArray = [[NSMutableArray alloc] init];
    
    
    _AddIngredientTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Whatcha got?"
                                                                                    attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.88 green:0.82 blue:0.75 alpha:0.75]}];
    _AddIngredientTextField.textColor = BRAND_BEIGE;
    
    [self.AddIngredientTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle ingredients


- (IBAction)removeIngredient:(id)sender {
//    IngredientCollectionViewCell *cell =  objc_getAssociatedObject(sender, @"removeIngredientButton");
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [_collectionView indexPathForCell: (UICollectionViewCell *)[[senderButton superview]superview]];
    
    [_ingredientsArray removeObjectAtIndex:indexPath.row];
    [_collectionView reloadData];
}

- (IBAction)addIngredient:(id)sender {
    if (self.AddIngredientTextField.text.length > 0) {
        NSString *currentIngredient = [self.AddIngredientTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self.ingredientsArray addObject:currentIngredient];
        [self.collectionView reloadData];
        _AddIngredientTextField.text = @"";
        NSLog(@"%@", _ingredientsArray);
    } else {
        [ToastView showToastInParentView:self.view
                                withText:@"First, enter an ingredient."
                           withDuaration:2.0];
    }
}

#pragma mark - JSON fetching and seque

- (IBAction)searchRecipesClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if ([_ingredientsArray count] == 0){
        [ToastView showToastInParentView:self.view
                                withText:@"You haven't added any ingredients"
                           withDuaration:2.0];
        return;
    }
    
    btn.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSString *parameters = [@"search?key=" stringByAppendingFormat:@"%@&q=%@", API_KEY, [self getQueryString]];
    NSString *stringURL = [API_BASE_URL stringByAppendingString:parameters];
    NSURL *url = [[NSURL alloc] initWithString:stringURL];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError) {
                                   [self showToastOnMainThread:@"Trouble connecting. Check internet connection."];
                                   NSLog(@"%@", @"no connection");
                               } else {
                                   [self buildRecipesFromJSON:data];
                               }
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               btn.enabled = YES;
                           }];
}

- (NSString *)getQueryString {
    return [[self.ingredientsArray copy] componentsJoinedByString:@","];
}

- (void)buildRecipesFromJSON:(NSData *)objectNotation {
    NSError *error = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&error];
    if (error != nil) {
        
        [self showToastOnMainThread:@"An error occured."];
        NSLog(@"%@", @"error occured");

    } else if ([[parsedObject valueForKey:@"count"] integerValue] == 0) {
        
        [self showToastOnMainThread:@"No recpes found for ingredients."];
        NSLog(@"%@", @"no recipes found");
        
    } else {
        NSMutableArray *recipes = [[NSMutableArray alloc] init];
        NSArray *results = [parsedObject valueForKey:@"recipes"];
        
        for (NSDictionary *recipeDic in results) {
            
            TSPShortRecipe *recipe = [[TSPShortRecipe alloc] init];
            
            for (NSString *key in recipeDic) {
                if ([recipe respondsToSelector:NSSelectorFromString(key)]) {
                    [recipe setValue:[recipeDic valueForKey:key] forKey:key];
                }
            }
            
            [recipes addObject:recipe];
            
        }
        _recipesArray = recipes;

        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            [self performSegueWithIdentifier:@"SegueToShortRecipes" sender:self];
        }];
        
    }
}

- (void)showToastOnMainThread:(NSString *)text {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [ToastView showToastInParentView:self.view withText:text withDuaration:2.0];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueToShortRecipes"]) {
        TSPRecipeListTableViewController *shortRecipeListController = (TSPRecipeListTableViewController *) segue.destinationViewController;
        shortRecipeListController.recipesArray = _recipesArray;
    }
}

#pragma mark - orientation handling

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _navBorder.frame = CGRectMake(0, _bar.frame.size.height-1, _bar.frame.size.width, 1);
}

#pragma mark - Table Handling

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)_configureCell:(IngredientCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    cell.ingredientLabel.text = [self.ingredientsArray objectAtIndex:indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.ingredientsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IngredientCollectionViewCell *cell = (IngredientCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ItemView" forIndexPath:indexPath];
    [self _configureCell:cell forIndexPath:indexPath];
    [cell.removeIngredientButton addTarget:self action:@selector(removeIngredient:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self _configureCell:sizingCell forIndexPath:indexPath];
    return [sizingCell systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

@end
