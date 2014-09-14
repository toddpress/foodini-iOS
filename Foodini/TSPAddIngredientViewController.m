//
//  TSPAddIngredientViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPAddIngredientViewController.h"
#import "TSPRecipeListTableViewController.h"
#import "TSPTableViewCell.h"
#import "ToastView.h"
#import "UIView+Borders.h"
#import <objc/runtime.h>

@interface TSPAddIngredientViewController ()

@property NSMutableArray *aIngredients;
@property UINavigationBar *bar;
@property CGFloat *boundWidth;
@end

@implementation TSPAddIngredientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.boundWidth = 0;
    UIColor *teddycolor = [UIColor colorWithRed:0.88 green:0.82 blue:0.75 alpha:0.75];
    
    // Nav styles, etc...
    self.bar = self.navigationController.navigationBar;
    self.bar.barTintColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.24 alpha:0.75];
    self.bar.tintColor = [UIColor colorWithRed:0.95 green:0.43 blue:0.33 alpha:1];
    self.bar.translucent = YES;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(53, 7, 107, self.bar.frame.size.height);
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foodini_logo_nav.png"]];
    imgView.frame = CGRectMake(0, -1, 107, 44);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:imgView];
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0, _bar.frame.size.height-1, _bar.frame.size.width, 1)];
    
    [navBorder setBackgroundColor:[UIColor colorWithRed:0.89 green:0.94 blue:0.61 alpha:1]];
    [navBorder setOpaque:YES];
    [navBorder setTag:666];
    [_bar addSubview:navBorder];
    [self.navigationItem setTitleView:headerView];

    if (self.aIngredients == nil) {
        self.aIngredients = [[NSMutableArray alloc] init];
    }
    
    self.AddIngredientTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.AddIngredientTable.separatorColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:0.75];
    
    
    self.AddIngredientTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Whatcha got?" attributes:@{NSForegroundColorAttributeName: teddycolor}];
    self.AddIngredientTextField.textColor = [UIColor colorWithRed:0.88 green:0.82 blue:0.75 alpha:1];
    
    [self.AddIngredientTextField becomeFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.navigationItem.hidesBackButton) {
        CGRect frame = self.navigationItem.titleView.frame;
        frame.origin.x = 10;
        self.navigationItem.titleView.frame = frame;
    }
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
    [self.aIngredients removeObjectAtIndex:indexPath];
    [self.AddIngredientTable reloadData];
}

- (IBAction)addIngredient:(id)sender {
    if (self.AddIngredientTextField.text.length > 0) {
        NSString *trimmedString = [self.AddIngredientTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *currentIngredient = [[NSString alloc] initWithString:trimmedString];
        [self.aIngredients addObject:currentIngredient];
        [self.AddIngredientTable reloadData];
        self.AddIngredientTextField.text = @"";
    } else {
        [ToastView showToastInParentView:self.view withText:@"First, enter an ingredient." withDuaration:2.0];
    }
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    for (UIView *subview in [self.bar subviews]) {
        if (subview.tag == 666) {
            [subview setAlpha:0.0];
        }
    }
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.bar.frame.size.height-1,self.bar.frame.size.width, 1)];
    [navBorder setBackgroundColor:[UIColor colorWithRed:0.31 green:0.34 blue:0.41 alpha:1]];
    [navBorder setOpaque:YES];
    [navBorder setTag:666];
    [self.bar addSubview:navBorder];
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

#pragma mark - segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.aIngredients count] > 0) {
        return YES;
    } else {
        [ToastView showToastInParentView:self.view withText:@"You haven't added any ingrediets" withDuaration:2.0];
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueToShortRecipes"]) {
        NSString *queryString = [self getQueryString];
        TSPRecipeListTableViewController *shortRecipeListController = (TSPRecipeListTableViewController *) segue.destinationViewController;
        shortRecipeListController.queryString = queryString;
    }
}

- (NSString *)getQueryString {
    return [[self.aIngredients copy] componentsJoinedByString:@","];
}
@end
