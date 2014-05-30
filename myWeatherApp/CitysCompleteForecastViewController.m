//
//  CitysCompleteForecastViewController.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/23/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "CitysCompleteForecastViewController.h"
#import "ForecastCell.h"
@interface CitysCompleteForecastViewController ()

@end

@implementation CitysCompleteForecastViewController

@synthesize weatherDataArray;

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
    
    [self.forecastTable registerNib:[UINib nibWithNibName:@"ForecastCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"forecastcell"];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegate Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [weatherDataArray count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"forecastcell";
    ForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setWeather:(WeatherList *)[weatherDataArray objectAtIndex:indexPath.row]];
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
