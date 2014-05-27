//
//  LocationSearchViewController.h
//  myWeatherApp
//
//  Created by Ganesh Somani on 5/21/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationAddedDelegate <NSObject>

-(void) locationAdded;

@end
@interface LocationSearchViewController : UIViewController <WebRequestDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchLocationTable;
@property (strong, nonatomic) UITableViewCell *previousCell;
@property (nonatomic, assign) id <LocationAddedDelegate> delegate;

@end
