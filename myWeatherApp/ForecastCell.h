//
//  ForecastCell.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/29/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherList.h"

@interface ForecastCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *minTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTempLabel;

@property (strong, nonatomic) WeatherList *weather;
@end
