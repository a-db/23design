//
//  TicketDetailVC.h
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

@interface TicketDetailVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

// Form Outlets
@property (strong, nonatomic) IBOutlet UILabel *ticketNumber;
@property (strong, nonatomic) IBOutlet UISegmentedControl *status;
@property (strong, nonatomic) IBOutlet UILabel *dateNow;
@property (strong, nonatomic) IBOutlet UITextField *customer;
@property (strong, nonatomic) IBOutlet UITextField *customerContact;
@property (strong, nonatomic) IBOutlet UITextField *customerEmail;
@property (strong, nonatomic) IBOutlet UITextField *customerPhone;
@property (strong, nonatomic) IBOutlet UITextField *dueDate;
@property (strong, nonatomic) IBOutlet UITextField *shipDate;
@property (strong, nonatomic) IBOutlet UITextField *terms;
@property (strong, nonatomic) IBOutlet UITextField *salesman;
@property (strong, nonatomic) IBOutlet UITextView *billingInfo;
@property (strong, nonatomic) IBOutlet UITextView *shippingInfo;
@property (strong, nonatomic) IBOutlet UISegmentedControl *printerUsed;
@property (strong, nonatomic) IBOutlet UITextView *jobDescription;
@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UITextField *material;
@property (strong, nonatomic) IBOutlet UITextView *finishing;

// View frame outlets
@property (strong, nonatomic) IBOutlet UIView *formView;
@property (strong, nonatomic) IBOutlet UIView *customerInfoView;

// Buttons
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

// Methods

// Used for incoming segue data
@property (strong, nonatomic) Ticket *ticket;
@property BOOL newTicket;

@end
