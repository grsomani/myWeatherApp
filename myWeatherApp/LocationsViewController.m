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
#import "WeatherList.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController

NSMutableArray *citiesList;

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
    citiesList = [NSMutableArray arrayWithArray:[[AppContext sharedAppContext] getSavedCities]];
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
    if ([citiesList count] == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:((CitiesSaved *)[citiesList objectAtIndex:0]).name forKey:@"selectedCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.locationTable reloadData];
}

#pragma mark - UITableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([citiesList count])
    {
        [self.locationTable setEditing:YES];
    }
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [citiesList removeObjectAtIndex:indexPath.row];
        [[AppContext sharedAppContext] deleteCity:cell.textLabel.text];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
        [tableView reloadData];
    }
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
