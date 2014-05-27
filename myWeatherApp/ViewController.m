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
#import "WeatherList.h"
#import "CityTemperature.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize pageViewController = _pageViewController;
CLLocationManager *locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
//    [locationManager startUpdatingLocation];
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(bringLocationView)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
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
        
        self.addLocationBtn.hidden=NO;
        [self.view bringSubviewToFront:self.addLocationBtn];
        [self.addLocationBtn addTarget:self action:@selector(bringLocationView) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        //Get Last Selected City
        self.addLocationBtn.hidden=YES;
        
        self.temperatureLabel.hidden=NO;
        self.weatherDescLabel.hidden=NO;
        self.tempMinMaxLabel.hidden=NO;
        
        NSString *selectedCityName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"]];
        if(selectedCityName != nil)
        {
            [self.temperatureLabel setText:@"Loading.."];
            [self.weatherDescLabel setText:@""];
            [self.tempMinMaxLabel setText:@""];
            [[AppContext sharedAppContext] getWeatherDataForCity:selectedCityName];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) bringLocationView
{
    LocationsViewController *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationsViewController"];
    [self presentViewController:locationView animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);

    // Stop Location Manager
    [locationManager stopUpdatingLocation];
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
        index = ((CitysCompleteForecastViewController*) viewController).pageIndex;
    else
        index = ((PageContentViewController*) viewController).pageIndex;
    
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
        index = ((CitysCompleteForecastViewController*) viewController).pageIndex;
    else
        index = ((PageContentViewController*) viewController).pageIndex;
    
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
        CitysCompleteForecastViewController *forecastController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForecastView"];
        forecastController.view.backgroundColor=[UIColor redColor];
        forecastController.pageIndex = index;
        return forecastController;
    }
    return nil;
    
}

#pragma mark - WebService Delegate Methods
-(void)didSucceedToFetchJSONData:(NSArray *)cityWeatherArray
{
    WeatherList *probablyTodayList = (WeatherList *)[cityWeatherArray objectAtIndex:0];
    {
        [self.temperatureLabel setText:[NSString stringWithFormat:@"%.02f%@C",[[probablyTodayList.city_temp valueForKey:@"day"] floatValue]-273.15, @"\u00B0" ] ];
        [self.weatherDescLabel setText:[[probablyTodayList.weather objectAtIndex:0] valueForKey:@"description"]];
        [self.tempMinMaxLabel setText:[NSString stringWithFormat:@"Min : %.02f%@C Max : %.02f%@C",[[probablyTodayList valueForKeyPath:@"city_temp.min"] floatValue]-273.15, @"\u00B0", [[probablyTodayList valueForKeyPath:@"city_temp.max"] floatValue]-273.15, @"\u00B0" ]];
        self.moreDetailsBtn.hidden=NO;
    }
}

-(void)didFailedToFetchJSONData:(NSError *)error
{
    
}
@end
