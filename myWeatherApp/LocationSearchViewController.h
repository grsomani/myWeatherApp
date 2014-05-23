//
//  LocationSearchViewController.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/21/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSearchViewController : UIViewController <WebRequestDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchLocationTable;

@end
