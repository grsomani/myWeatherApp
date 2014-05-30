//
//  LocationSearchViewController.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/21/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LocationSearchViewController.h"
#import "CityList.h"

@interface LocationSearchViewController ()

@end

@implementation LocationSearchViewController

NSArray *searchResultsArray;

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
    self.title = @"Search City";
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.searchBar becomeFirstResponder];
  
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.searchBar.delegate = self;
    searchResultsArray = nil;
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) done
{
    if(_previousCell != nil)
    {
        NSIndexPath *indexPath = [_searchLocationTable indexPathForCell:_previousCell];

        [[AppContext sharedAppContext] saveNewCityWithCityName:[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"name"] andCityId:[[searchResultsArray objectAtIndex:indexPath.row] valueForKey:@"cityId"]];
        if([self.delegate respondsToSelector:@selector(locationAdded)])
        {
            [self.delegate locationAdded];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
    [AppContext sharedAppContext].delegate=self;
    [[AppContext sharedAppContext] fetchCityListForKeyword:searchBar.text];
    [self.searchBar resignFirstResponder];
    [self showLoadingSpinner:YES];
}

#pragma mark - WebServices Delegate
-(void)didSucceedToFetchJSONData:(NSArray *)cityWeatherArray;
{
    searchResultsArray = [NSArray arrayWithArray:cityWeatherArray];
    [self.searchLocationTable reloadData];
    [self showLoadingSpinner:NO];
}
-(void)didFailedToFetchJSONData:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                              @"Failure" message:@"Failed to search. Please try again" delegate:self
                                             cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    NSLog(@"Failed to Search due to %@",error.description);
    [self showLoadingSpinner:NO];
}

#pragma - TableView Delegate Methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultsArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = ((CityList *)[searchResultsArray objectAtIndex:indexPath.row]).name;
    
    if([_previousCell.textLabel.text isEqualToString:cell.textLabel.text])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _previousCell.accessoryType=UITableViewCellAccessoryNone;
    _previousCell=cell;
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

#pragma mark - Progress Spinner Delegate Methods
-(void)showLoadingSpinner:(BOOL)isLoading
{
    if (isLoading && !HUD)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
    }
    else
    {
        [HUD hide:YES];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
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
