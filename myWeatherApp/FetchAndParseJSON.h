//
//  FetchAndParseJSON.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/22/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebRequestDelegate <NSObject>

-(void)didSucceedToFetchJSONData:(NSArray *)cityWeatherArray;
-(void)didFailedToFetchJSONData:(NSError *)error;

@end

@interface FetchAndParseJSON : NSObject

@property (nonatomic, assign) id <WebRequestDelegate> delegate;

+(FetchAndParseJSON *)sharedFetchAndParseJSON;
- (void)getWeatherDataForCity:(NSString *)cityName;
- (void)getCityListForKeyword:(NSString *)keyword;

@property (strong, nonatomic) NSArray *cityWeatherArray;
@property (strong, nonatomic) NSArray *searchCityList;

@end
