//
//  AppContext.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/26/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CitiesSaved.h"


@protocol WebRequestDelegate <NSObject>

-(void)didSucceedToFetchJSONData:(NSArray *)cityWeatherArray;
-(void)didFailedToFetchJSONData:(NSError *)error;

@end

@interface AppContext : NSObject

@property (nonatomic, assign) id <WebRequestDelegate> delegate;

+(AppContext *)sharedAppContext;
- (void)fetchWeatherDataForCity:(CitiesSaved *)city;
- (void)fetchCityListForKeyword:(NSString *)keyword;
- (void)fetchCityListForLat:(float )latitue andLong:(float )longitute;

- (void)saveNewCityWithCityName:(NSString *)cityName andCityId:(NSString *)cityId;
-(void) deleteCity:(NSString *)cityName;

- (NSArray *)getSavedCityWithName:(NSString *)cityName;
- (NSArray *)getSavedCities;

- (void)saveCityWeatherForecastForCity:(CitiesSaved *) cityName;
- (void)getWeatherDataForCity:(CitiesSaved *)city;

@property (strong, nonatomic) NSArray *cityWeatherArray;
@property (strong, nonatomic) NSArray *searchCityList;

@end
