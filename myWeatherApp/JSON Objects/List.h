//
//  List.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/22/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Temperature.h"
#import "Weather.h"

@interface List : NSObject

@property (strong, nonatomic) NSString *dt;
@property (strong, nonatomic) NSDictionary *temp;
@property (strong, nonatomic) NSString *pressure;
@property (strong, nonatomic) NSString *humidity;
@property (strong, nonatomic) NSArray *weather;
@property (strong, nonatomic) NSString *speed;
@property (strong, nonatomic) NSString *deg;
@property (strong, nonatomic) NSString *clouds;
@property (strong, nonatomic) NSString *rain;

@end
