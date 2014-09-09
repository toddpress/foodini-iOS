//
//  TSPAddIngredientViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/7/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPAddIngredientViewController.h"
#import "TSPTableViewCell.h"
#import "ToastView.h"
#import <objc/runtime.h>

@interface TSPAddIngredientViewController ()

@property NSMutableArray *aIngredients;

@end

@implementation TSPAddIngredientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.aIngredients = [[NSMutableArray alloc] init];
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

- (NSString *)getQueryString {
    return [[self.aIngredients copy] componentsJoinedByString:@","];
}
@end
