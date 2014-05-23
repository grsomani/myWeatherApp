//
//  Weather.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/22/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (strong, nonatomic) NSString *idty;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *icon;

@end
