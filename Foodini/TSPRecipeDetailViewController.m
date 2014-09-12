//
//  TSPRecipeDetailViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/12/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPRecipeDetailViewController.h"

@interface TSPRecipeDetailViewController ()

@end

@implementation TSPRecipeDetailViewController

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
    self.API_KEY = @"0051927f71d94e11d2dcdda167b4559c";
    self.API_GET = @"http://food2fork.com/api/get?key=";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
