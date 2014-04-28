//
//  TicketsVC.h
//  testApp
//
//  Created by Aaron Burke on 10/8/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
