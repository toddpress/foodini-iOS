//
//  TSPWebViewController.m
//  Foodini
//
//  Created by Todd Presley on 9/14/14.
//  Copyright (c) 2014 thocknice. All rights reserved.
//

#import "TSPWebViewController.h"
#import "TSPRecipeListTableViewController.h"

@interface TSPWebViewController ()

@end

@implementation TSPWebViewController
- (IBAction)unwindToList:(id)sender {
     [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString: self.strUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    self.webv.suppressesIncrementalRendering = @YES;

    @try {
        [self.webv loadRequest:urlRequest];
    } @catch(NSException *e) {
        NSLog(@"%@", e);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation



@end
