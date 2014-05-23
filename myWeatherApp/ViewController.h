//
//  ViewController.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/20/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController
<
    UIPageViewControllerDataSource,
    CLLocationManagerDelegate,
    WebRequestDelegate
>

@property(strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMinMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreDetailsLabel;

@end
