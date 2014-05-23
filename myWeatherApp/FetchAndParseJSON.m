//
//  FetchAndParseJSON.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/22/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "FetchAndParseJSON.h"
#import "List.h"
#import "CityList.h"

#define API_KEY @"xxxx"

@implementation FetchAndParseJSON


+(FetchAndParseJSON *)sharedFetchAndParseJSON
{
    static FetchAndParseJSON* _sharedMySingleton = nil;
    @synchronized(self)
    {
        if (!_sharedMySingleton)
            _sharedMySingleton = [[self alloc] init];
        
        return _sharedMySingleton;
    }
    
    return nil;
}

- (void)getWeatherDataForCity:(NSString *)cityName
{
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14&APPID=%@",  cityName, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate didFailedToFetchJSONData:error];
        } else {
            [self parseWeatherJSONData:data];
        }
    }];
}

-(void)getCityListForKeyword:(NSString *)keyword
{
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?q=%@&type=like&mode=json&APPID=%@",  keyword, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate didFailedToFetchJSONData:error];
        } else {
            [self parseCityListJSONData:data];
        }
    }];
}

- (void) parseWeatherJSONData:(NSData *)data
{
    NSError *localError;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    NSArray *results = [parsedObject valueForKey:@"list"];
    
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *ListDic in results) {
        List *list = [[List alloc] init];
        
        for (NSString *key in ListDic) {
            if ([list respondsToSelector:NSSelectorFromString(key)]) {
                [list setValue:[ListDic valueForKey:key] forKey:key];
            }
        }
        
        [listArray addObject:list];
    }
    self.cityWeatherArray = [NSArray arrayWithArray:listArray];
    if(self.cityWeatherArray)
        [self.delegate didSucceedToFetchJSONData:self.cityWeatherArray];
}

- (void) parseCityListJSONData:(NSData *)data
{
    NSError *localError;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    NSArray *results = [parsedObject valueForKey:@"list"];
    
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *ListDic in results) {
        CityList *list = [[CityList alloc] init];
        
        for (NSString *key in ListDic) {
            if ([list respondsToSelector:NSSelectorFromString(key)]) {
                [list setValue:[ListDic valueForKey:key] forKey:key];
            }
        }
        
        [listArray addObject:list];
    }
    self.searchCityList = [NSArray arrayWithArray:listArray];
    if(self.searchCityList)
        [self.delegate didSucceedToFetchJSONData:self.searchCityList];
}

@end
