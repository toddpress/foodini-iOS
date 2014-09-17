//
//  TSPAddIngredientViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//
#import <objc/runtime.h>
#import "TSPAddIngredientViewController.h"
#import "TSPTableViewCell.h"

#import "TSPRecipeListTableViewController.h"

#import "ToastView.h"
#import "Loader.h"

#import "Constants.h"

@interface TSPAddIngredientViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchRecipesButton;

@property NSMutableArray *aIngredients;
@property UINavigationBar *bar;
@property UIView *navBorder;
@property UIView *logoImg;
@property UIView *rootView;

@end

@implementation TSPAddIngredientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rootView = [[[UIApplication sharedApplication] keyWindow]
                        rootViewController].view;

    //
    // Navigation Bar Styling, etc
    //
    
    _bar = self.navigationController.navigationBar;
    _bar.barTintColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.24 alpha:0.75];
    _bar.tintColor = BRAND_RED;
    _bar.translucent = YES;
    
    // logo
    
    _logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foodini_logo_nav.png"]];
    _logoImg.frame = CGRectMake(0, self.bar.frame.origin.y, 107, self.bar.frame.size.height);
    _logoImg.contentMode = UIViewContentModeScaleAspectFit;
    
    // bottom border
    
    _navBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.bar.frame.size.height-1, self.bar.frame.size.width, 1)];
    UIView *border = _navBorder;
    [border setBackgroundColor:BRAND_GREEN];
    [border setOpaque:YES];
    [self.bar addSubview:border];
    

    if (_aIngredients == nil) {
        _aIngredients = [[NSMutableArray alloc] init];
    }
    
    _AddIngredientTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _AddIngredientTable.separatorColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.75];
    
    
    _AddIngredientTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Whatcha got?" attributes:@{NSForegroundColorAttributeName: BRAND_BEIGE}];
    _AddIngredientTextField.textColor = [UIColor colorWithRed:0.88 green:0.82 blue:0.75 alpha:1];
    
    [self.AddIngredientTextField becomeFirstResponder];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [_rootView insertSubview:_logoImg atIndex:2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle ingredients


- (IBAction)removeIngredient:(id)sender {
    TSPTableViewCell *cell = (TSPTableViewCell *)  objc_getAssociatedObject(sender, @"removeIngredientButton");
    NSInteger indexPath = [[self.AddIngredientTable indexPathForCell:cell] row];
    [_aIngredients removeObjectAtIndex:indexPath];
    [_AddIngredientTable reloadData];
}

- (IBAction)addIngredient:(id)sender {
    if (self.AddIngredientTextField.text.length > 0) {
        NSString *currentIngredient = [self.AddIngredientTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self.aIngredients addObject:currentIngredient];
        [self.AddIngredientTable reloadData];
        _AddIngredientTextField.text = @"";
    } else {
        [ToastView showToastInParentView:self.view withText:@"First, enter an ingredient." withDuaration:2.0];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _navBorder.frame = CGRectMake(0, _bar.frame.size.height-1, _bar.frame.size.width, 1);
    _logoImg.frame = CGRectMake(0, self.bar.frame.origin.y, 107, self.bar.frame.size.height);
}

#pragma mark - Table Handling

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aIngredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *ingredient = [self.aIngredients objectAtIndex:indexPath.row];
    TSPTableViewCell *cell = (TSPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"removeIngredientCell" forIndexPath:indexPath];
   
    cell.ingredientLabel.text = ingredient;
    objc_setAssociatedObject(cell.ingredientCellButton, @"removeIngredientButton", cell, 1);
    return cell;
}

#pragma mark - JSON fetching and seque

/*
 move all of the asyc json calls here, then transition when loaded or display error msg -- network or null results
*/

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.aIngredients count] > 0) {
        return YES;
    } else {
        [ToastView showToastInParentView:self.view withText:@"You haven't added any ingredients" withDuaration:2.0];
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueToShortRecipes"]) {
        NSString *queryString = [self getQueryString];
        TSPRecipeListTableViewController *shortRecipeListController = (TSPRecipeListTableViewController *) segue.destinationViewController;
        shortRecipeListController.queryString = queryString;
        [self.logoImg removeFromSuperview];
    }
}

- (NSString *)getQueryString {
    return [[self.aIngredients copy] componentsJoinedByString:@","];
}
@end
