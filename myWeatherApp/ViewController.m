//
//  ViewController.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/20/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "ViewController.h"
#import "PageContentViewController.h"
#import "CitysCompleteForecastViewController.h"
#import "LocationsViewController.h"
#import "CitiesSaved.h"
#import "WeatherList.h"
#import "CityTemperature.h"
#import "MoreDetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize pageViewController = _pageViewController;
@synthesize moreDetailsPopover;

CLLocationManager *locationManager;
CitysCompleteForecastViewController* forecastViewController;
NSArray *comingWeatherArray;

CLGeocoder *geoCoder;


- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;

	// Do any additional setup after loading the view, typically from a nib.
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = (PageContentViewController *)[self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    //Get Location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    [locationManager startUpdatingLocation];
    

    
    UIBarButtonItem *LocationAdder = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(bringLocationAdderView)];
    self.navigationItem.rightBarButtonItem = LocationAdder;
    
    
    UIBarButtonItem *LocationSelector = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"filter.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(bringLocationSelectorView)];
    self.navigationItem.leftBarButtonItem = LocationSelector;
}

-(void) viewWillAppear:(BOOL)animated
{
    [AppContext sharedAppContext].delegate=self;
    NSArray *totalCities = [[AppContext sharedAppContext] getSavedCities];
    self.moreDetailsBtn.hidden=YES;
    
    if([totalCities count] == 0)
    {
        //Show add Locations Button
        self.temperatureLabel.hidden=YES;
        self.weatherDescLabel.hidden=YES;
        self.tempMinMaxLabel.hidden=YES;
        self.moreDetailsBtn.hidden=YES;
        self.cityName.hidden=YES;

        self.addLocationBtn.hidden=NO;
        [self.view bringSubviewToFront:self.addLocationBtn];
        [self.addLocationBtn addTarget:self action:@selector(bringLocationAdderView) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        //Get Last Selected City
        self.addLocationBtn.hidden=YES;
        self.cityName.hidden=YES;
        self.temperatureLabel.hidden=NO;
        self.weatherDescLabel.hidden=NO;
        self.tempMinMaxLabel.hidden=NO;
        self.cityName.hidden=NO;
        
        if([[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"])
        {
            NSString *selectedCityName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"]];
            [self.temperatureLabel setText:@"Loading.."];
            [self.weatherDescLabel setText:@""];
            [self.tempMinMaxLabel setText:@""];
            [self.cityName setText:@""];
            
            NSArray *citiesWithName = [[AppContext sharedAppContext] getSavedCityWithName:selectedCityName];
            if([citiesWithName count])
                [[AppContext sharedAppContext] getWeatherDataForCity:(CitiesSaved *)[citiesWithName objectAtIndex:0]];
        }
        else
        {
            [self.temperatureLabel setText:@"Loading.."];
            [self.weatherDescLabel setText:@""];
            [self.tempMinMaxLabel setText:@""];
            [self.cityName setText:@""];
            
            CitiesSaved *firstCityOnList = (CitiesSaved *)[totalCities objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:firstCityOnList.name forKey:@"selectedCity"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[AppContext sharedAppContext] getWeatherDataForCity:firstCityOnList];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) bringLocationAdderView
{
    LocationsViewController *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationsViewController"];
    locationView.title=@"Manage Cities";
    [self presentViewController:locationView animated:YES completion:nil];
}

-(void) bringLocationSelectorView
{
    LocationsViewController *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationsViewController"];
    locationView.title=@"Select City";
    locationView.isSelector = YES;
    [self presentViewController:locationView animated:YES completion:nil];
}

- (IBAction)bringMoreDetails:(UIButton *)sender
{
    MoreDetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"moredetailsview"];
    moreDetailsPopover = [[UIPopoverController alloc] initWithContentViewController:viewController];

    if(comingWeatherArray != nil)
    {
        WeatherList *TodayList = (WeatherList *)[comingWeatherArray objectAtIndex:0];
        
        viewController.pressureValue.text=[TodayList valueForKey:@"pressure"];
        viewController.windValue.text=[TodayList valueForKey:@"speed"];
        viewController.humidityValue.text=[TodayList valueForKey:@"humidity"];
    }

    moreDetailsPopover.delegate = self;
    moreDetailsPopover.popoverContentSize = CGSizeMake(644, 200); //your custom size.
    [moreDetailsPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"])
    {
        self.addLocationBtn.hidden = NO;
    }
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Latitude: %f Longitute: %f ", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [locationManager stopUpdatingLocation];

    if(![[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"])
    {
        self.cityName.hidden=NO;
        [self.temperatureLabel setText:@"Auto Loading.."];
        [self.weatherDescLabel setText:@""];
        [self.tempMinMaxLabel setText:@""];
        [self.cityName setText:@""];
        
        self.addLocationBtn.hidden = YES;
        [[AppContext sharedAppContext] fetchCityListForLat:newLocation.coordinate.latitude andLong:newLocation.coordinate.longitude];
    }
    
    // Stop Location Manager
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index;
    if( [viewController isKindOfClass:[CitysCompleteForecastViewController class]])
        index = ((CitysCompleteForecastViewController*) forecastViewController).pageIndex;
    else
    {
        index = ((PageContentViewController*) viewController).pageIndex;
        if(![self.cityName.text isEqualToString:@"Loading.."] && !self.cityName.hidden)
            self.moreDetailsBtn.hidden=NO;
    }
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index;
    if( [viewController isKindOfClass:[CitysCompleteForecastViewController class]])
    {
        self.moreDetailsBtn.hidden=YES;
        index = ((CitysCompleteForecastViewController*) forecastViewController).pageIndex;
    }
    else
    {
        index = ((PageContentViewController*) viewController).pageIndex;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == 2) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= 2) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    if(index == 0)
    {
        PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
        pageContentViewController.pageIndex = index;
        return pageContentViewController;
    }
    
    if(index == 1)
    {
        forecastViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForecastView"];
        forecastViewController.view.backgroundColor=[UIColor redColor];
        forecastViewController.pageIndex = index;
        forecastViewController.weatherDataArray = comingWeatherArray;
        return forecastViewController;
    }
    return nil;
    
}

#pragma mark - WebService Delegate Methods
-(void)didSucceedToFetchJSONData:(NSArray *)cityWeatherArray
{
    if([cityWeatherArray count])
    {
        comingWeatherArray = cityWeatherArray;
    }
    WeatherList *TodayList = (WeatherList *)[cityWeatherArray objectAtIndex:0];
    {
        self.addLocationBtn.hidden=YES;
        self.cityName.hidden=YES;
        self.temperatureLabel.hidden=NO;
        self.weatherDescLabel.hidden=NO;
        self.tempMinMaxLabel.hidden=NO;
        self.cityName.hidden=NO;
        
        [self.temperatureLabel setText:[NSString stringWithFormat:@"%.02f%@C",[[TodayList.city_temp valueForKey:@"day"] floatValue]-273.15, @"\u00B0" ] ];
        [self.weatherDescLabel setText:[[TodayList.weather objectAtIndex:0] valueForKey:@"description"]];
        [self.tempMinMaxLabel setText:[NSString stringWithFormat:@"Min : %.02f%@C Max : %.02f%@C",[[TodayList valueForKeyPath:@"city_temp.min"] floatValue]-273.15, @"\u00B0", [[TodayList valueForKeyPath:@"city_temp.max"] floatValue]-273.15, @"\u00B0" ]];
        [self.cityName setText:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"]];
        self.moreDetailsBtn.hidden=NO;
        [self.view bringSubviewToFront:self.moreDetailsBtn];
        
        if(forecastViewController != nil)
        {
            forecastViewController.weatherDataArray = cityWeatherArray;
            [forecastViewController.forecastTable reloadData];
        }
    }
}

-(void)didFailedToFetchJSONData:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                              @"Failure" message:@"Failed to fetch weather data. Please try Later" delegate:self
                                             cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}
@end
