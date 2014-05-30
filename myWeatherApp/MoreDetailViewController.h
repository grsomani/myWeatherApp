//
//  MoreDetailViewController.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/30/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pressureValue;
@property (weak, nonatomic) IBOutlet UILabel *windValue;
@property (weak, nonatomic) IBOutlet UILabel *humidityValue;

@end
