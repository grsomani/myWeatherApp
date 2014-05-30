//
//  CitiesSaved.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/30/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherList;

@interface CitiesSaved : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * cityID;
@property (nonatomic, retain) NSSet *city_weather;
@end

@interface CitiesSaved (CoreDataGeneratedAccessors)

- (void)addCity_weatherObject:(WeatherList *)value;
- (void)removeCity_weatherObject:(WeatherList *)value;
- (void)addCity_weather:(NSSet *)values;
- (void)removeCity_weather:(NSSet *)values;

@end
