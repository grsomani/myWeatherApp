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
#import "Reachability.h"

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

- (void)fetchWeatherDataForCity:(CitiesSaved *)city
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Device Offline" message:@"Please Check Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else
    {
        NSString *urlAsString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&cnt=14&APPID=%@",  city.cityID, API_KEY];
        NSURL *url = [[NSURL alloc] initWithString:urlAsString];
        
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                [self.delegate didFailedToFetchJSONData:error];
            } else {
                [self parseWeatherJSONData:data forCity:city];
            }
        }];
    }
}

-(void)fetchCityListForKeyword:(NSString *)keyword
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Device Offline" message:@"Please Check Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else
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
}

- (void)fetchCityListForLat:(float )latitue andLong:(float )longitute
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Device Offline" message:@"Please Check Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else
    {
        NSString *urlAsString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@", latitue, longitute, API_KEY];
        NSURL *url = [[NSURL alloc] initWithString:urlAsString];
        
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                [self.delegate didFailedToFetchJSONData:error];
            } else {
                [self parseCityListForLatAndLong:data];
            }
        }];
    }
}

- (void) parseWeatherJSONData:(NSData *)data forCity:(CitiesSaved *) city
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
        [self saveCityWeatherForecastForCity:city];
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
            if([key isEqualToString:@"id"])
            {
                [list setValue:[NSString stringWithFormat:@"%@", [ListDic valueForKey:key]] forKey:@"cityId"];
            }
            else if([key isEqualToString:@"name"])
            {
                [list setValue:[ListDic valueForKey:key] forKey:key];
            }
        }
        
        [listArray addObject:list];
    }
    self.searchCityList = [NSArray arrayWithArray:listArray];
    if(self.searchCityList)
        [self.delegate didSucceedToFetchJSONData:self.searchCityList];
}

-(void) parseCityListForLatAndLong:(NSData *)data
{
    NSError *localError;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
//    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    CityList *list = [[CityList alloc] init];
    for (NSString *key in parsedObject) {
        if([key isEqualToString:@"id"])
        {
            [list setValue:[NSString stringWithFormat:@"%@", [parsedObject valueForKey:key]] forKey:@"cityId"];
        }
        else if([key isEqualToString:@"name"])
        {
            [list setValue:[parsedObject valueForKey:key] forKey:key];
        }
    }
    if(list != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:list.name forKey:@"selectedCity"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self saveNewCityWithCityName:list.name andCityId:list.cityId];
        [self fetchWeatherDataForCity: (CitiesSaved *)[[self getSavedCityWithName:list.name] objectAtIndex:0]];
    }
}

- (void)saveNewCityWithCityName:(NSString *)cityName andCityId:(NSString *)cityId;
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"CitiesSaved"];
    NSError *error;
    NSArray *totalCitiesSaved = [[self sharedManagedObjectContext] executeFetchRequest:request error:&error ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@)", cityName];
    NSArray *arr = [totalCitiesSaved filteredArrayUsingPredicate:predicate];
    if ([arr count] > 0)
    {
        return;
    }
    else
    {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"CitiesSaved"                                                       inManagedObjectContext:[self sharedManagedObjectContext]];
        [object setValue:cityName forKey:@"name"];
        [object setValue:cityId forKey:@"cityID"];

        if (![[self sharedManagedObjectContext] save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
    }
}

-(void) deleteCity:(NSString *)cityName
{
    NSError *error;
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"CitiesSaved"];
    NSPredicate *query = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name='%@'",cityName]];
    [request setPredicate:query];
    NSArray *citiesArray = [[self sharedManagedObjectContext] executeFetchRequest:request error:&error];
    if ([citiesArray count]) {
        [[self sharedManagedObjectContext] deleteObject:[citiesArray objectAtIndex:0]];
        if (![[self sharedManagedObjectContext] save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        }
        
        if([cityName isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"selectedCity"]])
        {
            [self resetNSUserDefaults];
        }
    }
    else
    {
        NSLog(@"%@ does not exists",cityName);
    }
}

- (void)resetNSUserDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        if([key isEqualToString:@"selectedCity"])
            [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

-(NSArray *)getSavedCityWithName:(NSString *)cityName
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"CitiesSaved"];
    NSPredicate *query = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name='%@'",cityName]];
    [request setPredicate:query];
    NSError *error;
    NSArray *totalCitiesSaved = [[self sharedManagedObjectContext] executeFetchRequest:request error:&error];
    return totalCitiesSaved;
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

-(void) saveCityWeatherForecastForCity:(CitiesSaved *) city
{
    NSError *error;
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"CitiesSaved"];
    NSPredicate *query = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name='%@'",city.name]];
    [request setPredicate:query];
    NSArray *citiesArray = [[self sharedManagedObjectContext] executeFetchRequest:request error:&error];
    BOOL saveSuccuess = NO;
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
        
        if([citiesArray count])
        {
            NSManagedObject* cityObj = [citiesArray objectAtIndex:0];
            [(CitiesSaved *)cityObj addCity_weatherObject:(WeatherList *)object];
        }
        
        if (![[self sharedManagedObjectContext] save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        else
        {
            saveSuccuess = YES;
        }
    }
    if(saveSuccuess)
    {
        //Save Data Successfull, Now this Method Call Should return the latest Saved Data
        [self getWeatherDataForCity:city];
    }

}

- (void)getWeatherDataForCity:(CitiesSaved *)city
{
    NSError *error;
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"CitiesSaved"];
    NSPredicate *query = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name='%@'",city.name]];
    [request setPredicate:query];
    NSArray *citiesArray = [[self sharedManagedObjectContext] executeFetchRequest:request error:&error];
    if([citiesArray count])
    {
        //Data Exists Already in DB
        NSArray *weatherArray = (NSArray *)((CitiesSaved *)[citiesArray objectAtIndex:0]).city_weather;
        if([weatherArray count])
        {
            NSSortDescriptor *dateSorter = [[NSSortDescriptor alloc] initWithKey:@"dt" ascending:YES];
            NSArray *sortedArray = [weatherArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSorter]];
            
            WeatherList *probablyTodayList = (WeatherList *)[sortedArray objectAtIndex:0];
            NSDate *webDate = [NSDate dateWithTimeIntervalSince1970:[probablyTodayList.dt doubleValue]];
            NSDate *today = [NSDate date];
            
            [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&webDate interval:NULL forDate:webDate];
            [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&today interval:NULL forDate:[NSDate date]];
            
            if( [webDate isEqualToDate:today] )
            {
                //Data Not Stale
                if([self.delegate respondsToSelector:@selector(didSucceedToFetchJSONData:)])
                {
                    [self.delegate didSucceedToFetchJSONData:sortedArray];
                }
            }
            else
            {
                //Stale Data, delete old data, fetch Latest and Save it
                [[self sharedManagedObjectContext] deleteObject:[citiesArray objectAtIndex:0]];
                [self saveNewCityWithCityName:city.name andCityId:city.cityID];
                [self fetchWeatherDataForCity:city];
            }
        }
        else
        {
            //No weather Data in Core Data and Need to fetch it from Server
            [self fetchWeatherDataForCity:city];
        }
    }
    else
    {
        NSLog(@"City Not Selected By User");
    }
}

@end
