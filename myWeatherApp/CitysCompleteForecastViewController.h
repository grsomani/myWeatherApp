//
//  CitysCompleteForecastViewController.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/23/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitysCompleteForecastViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UITableView *forecastTable;
@property (nonatomic, strong) NSArray *weatherDataArray;
@end
