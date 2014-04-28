//
//  CustomerDetailVC.h
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@interface CustomerDetailVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *customerField;
@property (strong, nonatomic) IBOutlet UITextField *contactField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *phoneField;

@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;


// Used for incoming segue data
@property (strong, nonatomic) Customer *customer;
@property BOOL newCustomer;

@end
