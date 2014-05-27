//
//  LocationsViewController.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/21/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSearchViewController.h"

@interface LocationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LocationAddedDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITableView *locationTable;

@end
