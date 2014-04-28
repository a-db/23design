//
//  TicketDetailVC.m
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "TicketDetailVC.h"
#import "Customer.h"

@interface TicketDetailVC ()

// Picker usage
@property (nonatomic,strong) UIDatePicker *dueDatePicker;
@property (nonatomic,strong) UIDatePicker *shipDatePicker;
@property (nonatomic,strong) Customer *customerAtRow;
@property (nonatomic,strong) UIPickerView *customerPicker;
@property (strong, nonatomic) IBOutlet UIView *formBg;

// Array holds customer objects from DB
@property (nonatomic,strong) NSArray *customerArray;

// Alertviews
@property (nonatomic,strong) UIAlertView *deleteAlertView;

// Keyboard moving helpers
@property CGSize keyboardSize;
@property BOOL keyboardUp;

@end

@implementation TicketDetailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImage *patternImage = [UIImage imageNamed:@"grey_@2X.png"];
    self.formBg.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    self.formBg.layer.cornerRadius = 8;
    
    // Sets current date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString* dateStr = [dateFormatter stringFromDate:date];
    self.dateNow.text = dateStr;
    
    
    // Customize interface by whether it is displaying an existing ticket or creating a new one
    if (self.newTicket == TRUE) {
        // New ticket
        [self findLastTicketNumber];
        [self.editBtn setTitle:@"Save" forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        
        // Initialize new ticket
        self.ticket = [[Ticket alloc] init];
        
    } else {
        // Existing ticket
        [self disableInteraction];
        // Load ticket data into view
        [self loadTicket:self.ticket];
    }
    
    // Notify keyboard show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // Notify keyboard hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Pull in Customers list for use
    KCSCollection *customers = [KCSCollection collectionFromString:@"customers" ofClass:[Customer class]];
    KCSAppdataStore  *store = [KCSAppdataStore  storeWithCollection:customers options:nil];
    
    [store queryWithQuery:[KCSQuery query] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            self.customerArray = objectsOrNil;

        }
    } withProgressBlock:nil];
    
    // Setup textfield editing events
    [self textfieldEvents];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        return self.customerArray.count;
}

#pragma mark PickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.customerPicker) {
        self.customerAtRow = [self.customerArray objectAtIndex:row];
        return self.customerAtRow.companyName;
    } else {
        return @"testing";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    //Write the required logic here that should happen after you select a row in Picker View.
    
    if (pickerView == self.customerPicker) {
        //self.customer.text = [[self.customerArray objectAtIndex:row] objectForKey:@"companyName"];
        self.customerAtRow = [self.customerArray objectAtIndex:row];
        self.customer.text = self.customerAtRow.companyName;
        self.customerContact.text = self.customerAtRow.contact;
        self.customerEmail.text = self.customerAtRow.email;
        self.customerPhone.text = self.customerAtRow.phone;
        
        self.ticket.customer = [self.customerArray objectAtIndex:row];
    }
    
}

#pragma mark Custom Methods

- (void)disableInteraction
{
    self.status.userInteractionEnabled = NO;
    self.customer.userInteractionEnabled = NO;
    self.customer.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.customerContact.userInteractionEnabled = NO;
    self.customerContact.userInteractionEnabled = NO;
    self.customerEmail.userInteractionEnabled = NO;
    self.customerPhone.userInteractionEnabled = NO;
    self.dueDate.userInteractionEnabled = NO;
    self.dueDate.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.shipDate.userInteractionEnabled = NO;
    self.shipDate.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.terms.userInteractionEnabled = NO;
    self.terms.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.salesman.userInteractionEnabled = NO;
    self.salesman.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.billingInfo.userInteractionEnabled = NO;
    self.billingInfo.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.shippingInfo.userInteractionEnabled = NO;
    self.shippingInfo.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.printerUsed.userInteractionEnabled = NO;
    self.jobDescription.userInteractionEnabled = NO;
    self.jobDescription.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.quantity.userInteractionEnabled = NO;
    self.quantity.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.material.userInteractionEnabled = NO;
    self.material.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.finishing.userInteractionEnabled = NO;
    self.finishing.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
}

- (void)enableInteraction
{
    self.status.userInteractionEnabled = YES;
    self.customer.userInteractionEnabled = YES;
    self.customer.backgroundColor = [UIColor whiteColor];
    self.customerContact.userInteractionEnabled = YES;
    self.customerContact.userInteractionEnabled = YES;
    self.customerEmail.userInteractionEnabled = YES;
    self.customerPhone.userInteractionEnabled = YES;
    self.dueDate.userInteractionEnabled = YES;
    self.dueDate.backgroundColor = [UIColor whiteColor];
    self.shipDate.userInteractionEnabled = YES;
    self.shipDate.backgroundColor = [UIColor whiteColor];
    self.terms.userInteractionEnabled = YES;
    self.terms.backgroundColor = [UIColor whiteColor];
    self.salesman.userInteractionEnabled = YES;
    self.salesman.backgroundColor = [UIColor whiteColor];
    self.billingInfo.userInteractionEnabled = YES;
    self.billingInfo.backgroundColor = [UIColor whiteColor];
    self.shippingInfo.userInteractionEnabled = YES;
    self.shippingInfo.backgroundColor = [UIColor whiteColor];
    self.printerUsed.userInteractionEnabled = YES;
    self.jobDescription.userInteractionEnabled = YES;
    self.jobDescription.backgroundColor = [UIColor whiteColor];
    self.quantity.userInteractionEnabled = YES;
    self.quantity.backgroundColor = [UIColor whiteColor];
    self.material.userInteractionEnabled = YES;
    self.material.backgroundColor = [UIColor whiteColor];
    self.finishing.userInteractionEnabled = YES;
    self.finishing.backgroundColor = [UIColor whiteColor];
}

// Setup the Ticket object to save
- (void)saveTicket
{
    BOOL valid = [self validateTicket];
    if (valid) {

        self.ticket.billAddress = self.billingInfo.text;
        self.ticket.shipAddress = self.shippingInfo.text;
        self.ticket.terms = [NSNumber numberWithInt:[self.terms.text integerValue]];
        self.ticket.salesman = self.salesman.text;
        self.ticket.printer = [NSNumber numberWithInt:self.printerUsed.selectedSegmentIndex];
        self.ticket.jobDescription = self.jobDescription.text;
        self.ticket.quantity = [NSNumber numberWithInt:[self.quantity.text integerValue]];
        self.ticket.material = self.material.text;
        self.ticket.finishing = self.finishing.text;
        self.ticket.status = [NSNumber numberWithInt:self.status.selectedSegmentIndex];
        NSArray *words = [self.ticketNumber.text componentsSeparatedByString:@"#"];
        self.ticket.ticketNumber = [NSNumber numberWithInt:[[words objectAtIndex:1] integerValue]];
    }
}

// Method loads values into view from selected ticket
- (void)loadTicket:(Ticket *)ticketObj
{
    self.ticketNumber.text = [NSString stringWithFormat:@"Job #%d", [self.ticket.ticketNumber integerValue]];
    self.status.selectedSegmentIndex = [self.ticket.status integerValue];
    self.customer.text = [self.ticket.customer valueForKey:@"companyName"];
    self.customerContact.text = [self.ticket.customer valueForKey:@"contact"];
    self.customerEmail.text = [self.ticket.customer valueForKey:@"email"];
    self.customerPhone.text = [self.ticket.customer valueForKey:@"phone"];
    self.dueDate.text = [self formatDateForForm:self.ticket.dueDate];
    self.shipDate.text = [self formatDateForForm:self.ticket.shipDate];
    self.terms.text = [NSString stringWithFormat:@"%d", [self.ticket.terms integerValue]];
    self.salesman.text = self.ticket.salesman;
    self.billingInfo.text = self.ticket.billAddress;
    self.shippingInfo.text = self.ticket.shipAddress;
    self.printerUsed.selectedSegmentIndex = [self.ticket.printer integerValue];
    self.jobDescription.text = self.ticket.jobDescription;
    self.quantity.text = [NSString stringWithFormat:@"%d", [self.ticket.quantity integerValue]];
    self.material.text = self.ticket.material;
    self.finishing.text = self.ticket.finishing;
    
}

-(void)keyboardWillShow:(NSNotification *)notification {
    // Set keboard size from notification
    self.keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Animate the current view out of the way
    if ([self.jobDescription isFirstResponder] || [self.quantity isFirstResponder] || [self.material isFirstResponder] || [self.finishing isFirstResponder]) {
        [self moveViewUpForKeyboard];
    }
    NSLog(@"show kb fired");
}

-(void)keyboardWillHide:(NSNotification *)notification {
    // Animate the current view back to its original position
    if ([self.jobDescription isFirstResponder] || [self.quantity isFirstResponder] || [self.material isFirstResponder] || [self.finishing isFirstResponder]) {
        [self moveViewDownForKeyboard];
    }
}

- (void)moveViewUpForKeyboard
{
    [UIView animateWithDuration:0.3f animations:^ {
        self.formView.frame = CGRectMake(0, -self.keyboardSize.height, 768, 1024);
    }];
    self.keyboardUp = TRUE;
}

- (void)moveViewDownForKeyboard
{
    [UIView animateWithDuration:0.3f animations:^ {
        self.formView.frame = CGRectMake(0, 0, 768, 1024);
    }];
    self.keyboardUp = FALSE;
}

// Used to help view movement on textField select
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.quantity || self.quantity || self.material) {
        [self moveViewUpForKeyboard];
    }
}
// Used to help view movement on textView select
- (void)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == self.jobDescription || self.finishing) {
        [self moveViewUpForKeyboard];
    }
}

- (void)textfieldEvents
{
    // Due date field
    self.dueDatePicker = [[UIDatePicker alloc] init];
    self.dueDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.dueDatePicker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.dueDate.inputView = self.dueDatePicker;
    
    // Ship date field
    self.shipDatePicker = [[UIDatePicker alloc] init];
    self.shipDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.shipDatePicker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.shipDate.inputView = self.shipDatePicker;
    
    // Customer field
    //self.customerPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.customerPicker = [[UIPickerView alloc] init];
    self.customerPicker.hidden = NO;
    self.customerPicker.delegate = self;
    self.customerPicker.dataSource = self;
    self.customer.inputView = self.customerPicker;
}

- (void)pickerValueChanged:(id)sender
{
    
    if (sender == self.dueDatePicker) {
        NSDate *date = self.dueDatePicker.date;
        
        // Modify view data
        self.dueDate.text = [self formatDateForForm:date];
        
        // Add/modify data to ticket object
        self.ticket.dueDate = date;
    
        
    } else if (sender == self.shipDatePicker) {
        NSDate *date = self.shipDatePicker.date;
        
        // Modify view data
        self.shipDate.text = [self formatDateForForm:date];
        
        // Add/modify data to ticket object
        self.ticket.shipDate = date;
    }
}

// Convenience method for displaying dates in the form
- (NSString*)formatDateForForm:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString* dateStr = [dateFormatter stringFromDate:date];
    
    return dateStr;
}

// tag.0 = save/edit , tag.1 = delete/cancel
- (IBAction)onClick:(UIButton*)button
{
    if (button.tag == 0) {
        
        if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Save"]) {
            BOOL valid = [self validateTicket];
            if (valid) {
                [self saveTicket];
                NSLog(@"Save ticket ran");
                KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
                KCSLinkedAppdataStore *store = [KCSLinkedAppdataStore storeWithCollection:tickets options:nil];
                
                [store saveObject:self.ticket withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil == nil && objectsOrNil != nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save worked!"
                                                                        message:@"Saved the ticket"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                    
                    } else {
                        //save failed
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save failed"
                                                                        message:[errorOrNil localizedDescription]
                                                                       delegate:self
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        
                        [alert show];
                        
                    }
                } withProgressBlock:nil];
                
                [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
                [self.deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
                [self disableInteraction];
            }
        } else if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Edit"]) {
            NSLog(@"Edit selected");
            [self.editBtn setTitle:@"Save" forState:UIControlStateNormal];
            [self.deleteBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            [self enableInteraction];
        }
        
    } else if (button.tag == 1) {
        if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Cancel"]) {
            
            if (self.newTicket) {
                self.ticket = nil;
                [[self navigationController] popViewControllerAnimated:YES];
            } else {
                [self disableInteraction];
                [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
                [self.deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
            }

            
        } else if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Delete"]) {
            
            self.deleteAlertView = [[UIAlertView alloc] initWithTitle:@"Deleting Record!"
                                                            message:@"This will permanently delete the ticket. Is that ok?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:@"Cancel", nil];
            
            [self.deleteAlertView show];
            
        }
        
    }
}

// Actions taken during delete alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex && alertView == self.deleteAlertView)
    {
        KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
        KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:tickets options:nil];
        
        [store removeObject:self.ticket withCompletionBlock:^(unsigned long count, NSError *errorOrNil) {
            if (errorOrNil) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete failed", @"Delete Failed")
                                                                    message:[errorOrNil localizedFailureReason]
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                //delete successful - UI already updated
                NSLog(@"delete successful");
                self.ticket = nil;
                [[self navigationController] popViewControllerAnimated:YES];
            }
        } withProgressBlock:nil];
        NSLog(@"Delete ticket ran");
    }
}

// Validate input data (basic at the moment)
- (BOOL)validateTicket
{
    if (
        self.ticket.customer &&
        self.ticket.dueDate &&
        self.ticket.shipDate &&
        self.terms.text.length > 0 &&
        self.salesman.text.length > 0 &&
        self.billingInfo.text.length > 0 &&
        self.shippingInfo.text.length > 0 &&
        self.jobDescription.text.length > 0 &&
        self.quantity.text.length > 0 &&
        self.material.text.length > 0 &&
        self.finishing.text.length > 0
        ) {
        return TRUE;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input Error!"
                                                        message:@"Please fill in all fields."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
        return FALSE;
    }
    
    return FALSE;
}

// Finds the last ticket in the db to increment by 1 for new ticket number
- (void)findLastTicketNumber
{
    KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
    KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:tickets options:nil];
    
    KCSQuery* query = [KCSQuery query];
    KCSQuerySortModifier* dateSort = [[KCSQuerySortModifier alloc] initWithField:@"ticketNumber" inDirection:kKCSDescending];
    [query addSortModifier:dateSort];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            Ticket *lastTicket = objectsOrNil[0];
            self.ticketNumber.text = [NSString stringWithFormat:@"Job #%d", [lastTicket.ticketNumber integerValue] + 1];
            
        }
    } withProgressBlock:nil];
}

// Method removes the keyboard when clicking on anything but the keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    [self moveViewDownForKeyboard];
    
}

@end

