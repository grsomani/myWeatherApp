//
//  AppContext.m
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/26/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "AppContext.h"
#import "AppDelegate.h"
#import "List.h"
#import "CityList.h"
#import "WeatherList.h"
#import "CityTemperature.h"

#define API_KEY @"xxxx"

@implementation AppContext


+(AppContext *)sharedAppContext
{
    static AppContext* _sharedAppContext = nil;
    @synchronized(self)
    {
        if (!_sharedAppContext)
            _sharedAppContext = [[self alloc] init];
        
        return _sharedAppContext;
    }
    
    return nil;
}

-(NSManagedObjectContext *)sharedManagedObjectContext
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
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
            if([key isEqualToString:@"temp"])
            {
                Temperature *temperature = [[Temperature alloc] init];
                temperature.day = [NSString stringWithFormat:@"%.2f",[[ListDic valueForKeyPath:@"temp.day"] floatValue]];
                temperature.min = [NSString stringWithFormat:@"%.2f",[[ListDic valueForKeyPath:@"temp.min"] floatValue]];
                temperature.max = [NSString stringWithFormat:@"%.2f",[[ListDic valueForKeyPath:@"temp.max"] floatValue]];
                temperature.night = [NSString stringWithFormat:@"%.2f",[[ListDic valueForKeyPath:@"temp.night"] floatValue]];
                temperature.eve = [NSString stringWithFormat:@"%.2f",[[ListDic valueForKeyPath:@"temp.eve"] floatValue]];
                temperature.morn = [NSString stringWithFormat:@"%.2f",[[ListDic valueForKeyPath:@"temp.morn"] floatValue]];
                
                list.temp = temperature;
            }
            else if([key isEqualToString:@"dt"])
            {
                [list setValue:[NSString stringWithFormat:@"%ld", [[ListDic valueForKey:key] longValue]] forKey:key];
            }
            else if([key isEqualToString:@"speed"])
            {
                list.speed = [NSString stringWithFormat:@"%.2f",[[ListDic valueForKey:key] floatValue]];
            }
            else if([key isEqualToString:@"clouds"])
            {
                [list setValue:[NSString stringWithFormat:@"%d", [[ListDic valueForKey:key] intValue]] forKey:key];
            }
            else if([key isEqualToString:@"deg"])
            {
                [list setValue:[NSString stringWithFormat:@"%d", [[ListDic valueForKey:key] intValue]] forKey:key];
            }
            else if([key isEqualToString:@"humidity"])
            {
                [list setValue:[NSString stringWithFormat:@"%d", [[ListDic valueForKey:key] intValue]] forKey:key];
            }
            else if([key isEqualToString:@"pressure"])
            {
                [list setValue:[NSString stringWithFormat:@"%f", [[ListDic valueForKey:key] floatValue]] forKey:key];
            }
            else if([key isEqualToString:@"rain"])
            {
                [list setValue:[NSString stringWithFormat:@"%d", [[ListDic valueForKey:key] intValue]] forKey:key];
            }
            else if ([list respondsToSelector:NSSelectorFromString(key)]) {
                [list setValue:[ListDic valueForKey:key] forKey:key];
            }
        }
        
        [listArray addObject:list];
    }
    self.cityWeatherArray = [NSArray arrayWithArray:listArray];
    if(self.cityWeatherArray)
    {
        [self.delegate didSucceedToFetchJSONData:self.cityWeatherArray];
        [self saveCityWeatherForecast];
    }
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

-(void) saveNewCity:(NSString *)cityName
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"CitiesSaved"];
    NSError *error;
    NSArray *totalCitiesSaved = [[self sharedManagedObjectContext] executeFetchRequest:request error:&error ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@)",cityName];
    NSArray *arr = [totalCitiesSaved filteredArrayUsingPredicate:predicate];
    if ([arr count] > 0)
    {
        return;
    }
    else
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"CitiesSaved"                                                       inManagedObjectContext:[self sharedManagedObjectContext]];
        [object setValue:cityName forKey:@"name"];
        if (![[self sharedManagedObjectContext] save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
    }
}

-(NSArray *)getSavedCities
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"CitiesSaved"];
    NSError *error;
    NSArray *totalCitiesSaved = [[self sharedManagedObjectContext] executeFetchRequest:request error:&error];
    [totalCitiesSaved sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    NSArray *sortedArray = [totalCitiesSaved sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    return sortedArray;
}

/*
 @property (strong, nonatomic) NSString *deg;
 
 */
-(void) saveCityWeatherForecast
{
    NSError *error;
    for(List *daysWeather in self.cityWeatherArray)
    {
        NSManagedObject *object = (WeatherList *)[NSEntityDescription insertNewObjectForEntityForName:@"WeatherList"                                                       inManagedObjectContext:[self sharedManagedObjectContext]];
        [object setValue:daysWeather.dt forKey:@"dt"];
        [object setValue:daysWeather.speed forKey:@"speed"];
        [object setValue:daysWeather.clouds forKey:@"clouds"];
        [object setValue:daysWeather.rain forKey:@"rain"];
        [object setValue:daysWeather.pressure forKey:@"pressure"];
        [object setValue:daysWeather.humidity forKey:@"humidity"];
        [object setValue:daysWeather.weather forKey:@"weather"];
        [object setValue:daysWeather.deg forKey:@"deg"];
        
//        for (Temperature *cityTemp in daysWeather.temp)
        Temperature *cityTemp = daysWeather.temp;
        {
            CityTemperature *city_temp = (CityTemperature *)[NSEntityDescription insertNewObjectForEntityForName:@"CityTemperature" inManagedObjectContext:[self sharedManagedObjectContext]];
            [city_temp setValue:cityTemp.day forKey:@"day"];
            [city_temp setValue:cityTemp.min forKey:@"min"];
            [city_temp setValue:cityTemp.max forKey:@"max"];
            [city_temp setValue:cityTemp.night forKey:@"night"];
            [city_temp setValue:cityTemp.eve forKey:@"eve"];
            [city_temp setValue:cityTemp.morn forKey:@"morn"];
            
            [object setValue:city_temp forKey:@"city_temp"];
        }



    if (![[self sharedManagedObjectContext] save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
    }
}

@end