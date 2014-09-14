//
//  TSPRecipeDetailViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/12/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPRecipeDetailViewController.h"
#import "TSPWebViewController.h"
#import "TSPIngredientCell.h"
#import "UIView+Borders.h"

@interface TSPRecipeDetailViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TSPRecipeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];

    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    self.recipeTitle.text = self.titleText;


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *imgURL = [NSURL URLWithString:self.imageUrl];
        NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipeImage.image = [UIImage imageWithData:imgData];
        });
    });
    [self.detailsTable addTopBorderWithHeight:1.0f andColor:[UIColor colorWithRed:0.31 green:0.34 blue:0.41 alpha:1]];
    [self.recipeTitle addBottomBorderWithHeight:1.0f andColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]];
    
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SegueToWebView"]) {
        TSPWebViewController *wvc = segue.destinationViewController;
        wvc.strUrl = self.recipeUrl;

    }
}

@end
