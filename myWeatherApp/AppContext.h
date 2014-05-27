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
- (void)getWeatherDataForCity:(NSString *)cityName;
- (void)getCityListForKeyword:(NSString *)keyword;

- (void)saveNewCity:(NSString *)cityName;
- (NSArray *)getSavedCities;

- (void)saveCityWeatherForecast;

@property (strong, nonatomic) NSArray *cityWeatherArray;
@property (strong, nonatomic) NSArray *searchCityList;

@end
