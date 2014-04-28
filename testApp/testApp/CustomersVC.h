//
//  CustomersVC.h
//  testApp
//
//  Created by Aaron Burke on 10/9/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomersVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


// Outlets
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *searchFrame;

@end
