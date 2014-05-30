//
//  ForecastCell.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/29/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "ForecastCell.h"

@implementation ForecastCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setWeather:(WeatherList *)weather
{
    NSDate *webDate = [NSDate dateWithTimeIntervalSince1970:[weather.dt doubleValue]];
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&webDate interval:NULL forDate:webDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:webDate];
    
    [self.dateLabel setText:strDate];
    [self.descLabel setText:[[weather.weather objectAtIndex:0] valueForKey:@"description"]];
    [self.minTempLabel setText:[NSString stringWithFormat:@"Min : %.02f %@ C",[[weather valueForKeyPath:@"city_temp.min"] floatValue]-273.155, @"\u00B0"]];
    [self.maxTempLabel setText:[NSString stringWithFormat:@"Max : %.02f %@ C",[[weather valueForKeyPath:@"city_temp.max"] floatValue]-273.155, @"\u00B0"]];
}
@end
