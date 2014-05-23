//
//  LocationsViewController.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/21/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationSearchViewController.h"
#import "UILocationSearchNavViewController.h"
@interface LocationsViewController ()

@end

@implementation LocationsViewController

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
    // Do any additional setup after loading the view.
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender
{
    LocationSearchViewController *viewController =[[LocationSearchViewController alloc] init];
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationSearch"];
    UINavigationController *navigationController = [[UILocationSearchNavViewController alloc]initWithRootViewController:viewController ];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
