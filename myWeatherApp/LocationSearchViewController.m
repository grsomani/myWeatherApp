//
//  LocationSearchViewController.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/21/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "LocationSearchViewController.h"

@interface LocationSearchViewController ()

@end

@implementation LocationSearchViewController

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
    
    [self.searchBar becomeFirstResponder];
  
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.searchBar.delegate = self;
}

-(void) cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
{
//    [FetchAndParseJSON sharedFetchAndParseJSON].delegate=self;
//    [[FetchAndParseJSON sharedFetchAndParseJSON] getCityListForKeyword:searchBar.text];
    [self.searchBar resignFirstResponder];
}

#pragma mark - WebServices Delegate
-(void)didSucceedToFetchJSONData:(NSArray *)cityWeatherArray;
{
    
}
-(void)didFailedToFetchJSONData:(NSError *)error
{
    
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
