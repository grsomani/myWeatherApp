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
@synthesize isSelector;

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
    
    if(isSelector)
    {
        // Get the reference to the current toolbar buttons
        NSMutableArray *toolbarButtons = [self.toolbar.items mutableCopy];
        
        // This is how you remove the button from the toolbar and animate it
        [toolbarButtons removeObject:self.addButton];
        [self.toolbar setItems:toolbarButtons animated:YES];
   }
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
    if(_previousCell)
    {
        [[NSUserDefaults standardUserDefaults] setObject:_previousCell.textLabel.text forKey:@"selectedCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) locationAdded
{
    citiesList = [NSMutableArray arrayWithArray:[[AppContext sharedAppContext] getSavedCities]];
    if ([citiesList count] == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:((CitiesSaved *)[citiesList objectAtIndex:0]).name forKey:@"selectedCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self.locationTable reloadData];
}

#pragma mark - UITableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([citiesList count] && !isSelector)
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
    cell.accessoryType=UITableViewCellAccessoryNone;
    if(!_previousCell)
    {
        if(isSelector && [cell.textLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"]])
        {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
    }
    else if([_previousCell.textLabel.text isEqualToString:cell.textLabel.text])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSelector)
    {
        _previousCell = [tableView cellForRowAtIndexPath:indexPath];
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
