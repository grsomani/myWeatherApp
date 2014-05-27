//
//  LocationsViewController.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/21/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LocationsViewController.h"
#import "UILocationSearchNavViewController.h"
#import "CitiesSaved.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController

NSArray *citiesList;

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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    citiesList = [NSArray arrayWithArray:[[AppContext sharedAppContext] getSavedCities]];
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender
{
    LocationSearchViewController *viewController =[[LocationSearchViewController alloc] init];
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationSearch"];
    viewController.delegate = self;
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

-(void) locationAdded
{
    citiesList = [NSArray arrayWithArray:[[AppContext sharedAppContext] getSavedCities]];
    [self.locationTable reloadData];
}

#pragma mark - UITableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [citiesList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = ((CitiesSaved *)[citiesList objectAtIndex:indexPath.row]).name;
    return cell;
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
