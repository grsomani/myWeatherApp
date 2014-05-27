//
//  AppContext.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/26/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WebRequestDelegate <NSObject>

-(void)didSucceedToFetchJSONData:(NSArray *)cityWeatherArray;
-(void)didFailedToFetchJSONData:(NSError *)error;

@end

@interface AppContext : NSObject

@property (nonatomic, assign) id <WebRequestDelegate> delegate;

+(AppContext *)sharedAppContext;
- (void)fetchWeatherDataForCity:(NSString *)cityName;
- (void)fetchCityListForKeyword:(NSString *)keyword;

- (void)saveNewCity:(NSString *)cityName;
-(void) deleteCity:(NSString *)cityName;

- (NSArray *)getSavedCities;

- (void)saveCityWeatherForecastForCity:(NSString *) cityName;
- (void)getWeatherDataForCity:(NSString *)cityName;

@property (strong, nonatomic) NSArray *cityWeatherArray;
@property (strong, nonatomic) NSArray *searchCityList;

@end
