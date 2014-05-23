//
//  Temperature.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/22/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Temperature : NSObject

@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) NSString *min;
@property (strong, nonatomic) NSString *max;
@property (strong, nonatomic) NSString *night;
@property (strong, nonatomic) NSString *eve;
@property (strong, nonatomic) NSString *morn;

@end
