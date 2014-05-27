//
//  CityTemperature.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/26/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CityTemperature : NSManagedObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * min;
@property (nonatomic, retain) NSString * max;
@property (nonatomic, retain) NSString * night;
@property (nonatomic, retain) NSString * eve;
@property (nonatomic, retain) NSString * morn;

@end
