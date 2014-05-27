//
//  WeatherList.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/26/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityTemperature;

@interface WeatherList : NSManagedObject

@property (nonatomic, retain) NSString * dt;
@property (nonatomic, retain) NSString * pressure;
@property (nonatomic, retain) NSString * speed;
@property (nonatomic, retain) NSString * clouds;
@property (nonatomic, retain) NSString * rain;
@property (nonatomic, retain) id weather;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * deg;
@property (nonatomic, retain) CityTemperature *city_temp;

@end
