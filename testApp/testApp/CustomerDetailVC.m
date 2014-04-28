//
//  CustomerDetailVC.m
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "CustomerDetailVC.h"
#import "Ticket.h"
#import "TicketTableCell.h"
#import "TicketDetailVC.h"
#import <KinveyKit/KinveyKit.h>

@interface CustomerDetailVC ()

@property (nonatomic, strong) NSArray* tableObjects;
@property (strong, nonatomic) IBOutlet UIView *formBg;

@end

@implementation CustomerDetailVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImage *patternImage = [UIImage imageNamed:@"grey_@2X.png"];
    self.formBg.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    self.formBg.layer.cornerRadius = 8;
    
    if (self.newCustomer == TRUE) {
        // New Customer
        [self.editBtn setTitle:@"Save" forState:UIControlStateNormal];
        [self.deleteBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        
        // Initialize new ticket
        self.customer = [[Customer alloc] init];
        
    } else {
        // Existing ticket
        [self disableInteraction];
        // Load ticket data into view
        [self loadCustomer:self.customer];
        
        // Load tickets associated with customer
        KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
        KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:tickets options:nil];
        
        NSString *customerId = self.customer.kinveyObjectId;
        
        KCSQuery *query = [KCSQuery queryOnField:@"customer._id" withExactMatchForValue:customerId];
        KCSQuerySortModifier* dateSort = [[KCSQuerySortModifier alloc] initWithField:@"ticketNumber" inDirection:kKCSDescending];
        [query addSortModifier:dateSort];
        
        [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                self.tableObjects = objectsOrNil;
                [self.tableView reloadData];
            }
        } withProgressBlock:nil];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableObjects) {
        return self.tableObjects.count;
    }
    return  0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketCell"];
    if (cell) {
        if (self.tableObjects) {
            [cell createCell:[self.tableObjects objectAtIndex:indexPath.row]];
        }
        
        cell.bgImgView.layer.cornerRadius = 8;
        cell.bgImgView.layer.shouldRasterize = YES;
        cell.bgImgViewShadow.layer.cornerRadius = 8;
        cell.bgImgViewShadow.layer.shouldRasterize = YES;
        
        return cell;
    }
    return nil;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
}

- (void)disableInteraction
{
    self.customerField.userInteractionEnabled = NO;
    self.customerField.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    self.contactField.userInteractionEnabled = NO;
    self.contactField.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    self.emailField.userInteractionEnabled = NO;
    self.emailField.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    self.phoneField.userInteractionEnabled = NO;
    self.phoneField.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
}

- (void)enableInteraction
{
    self.customerField.userInteractionEnabled = YES;
    self.customerField.backgroundColor = [UIColor whiteColor];
    
    self.contactField.userInteractionEnabled = YES;
    self.contactField.backgroundColor = [UIColor whiteColor];
    
    self.emailField.userInteractionEnabled = YES;
    self.emailField.backgroundColor = [UIColor whiteColor];
    
    self.phoneField.userInteractionEnabled = YES;
    self.phoneField.backgroundColor = [UIColor whiteColor];
}

- (void)loadCustomer:(Customer*)customerInfo
{
    // Populate textfields
    self.customerField.text = self.customer.companyName;
    self.contactField.text = self.customer.contact;
    self.emailField.text = self.customer.email;
    self.phoneField.text = self.customer.phone;
}

// Setup the Customer object for saving
- (void)saveCustomer
{
    BOOL valid = [self validateCustomer];
    if (valid) {
        self.customer.companyName = self.customerField.text;
        self.customer.contact = self.contactField.text;
        self.customer.email = self.emailField.text;
        self.customer.phone = self.phoneField.text;
    }
}

- (IBAction)onClick:(UIButton*)button
{
    if (button.tag == 0) {
        
        if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Save"]) {
            BOOL valid = [self validateCustomer];
            if (valid) {
                [self saveCustomer];
                
                KCSCollection *customers = [KCSCollection collectionFromString:@"customers" ofClass:[Customer class]];
                KCSLinkedAppdataStore *store = [KCSLinkedAppdataStore storeWithCollection:customers options:nil];
                
                [store saveObject:self.customer withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil == nil && objectsOrNil != nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save worked!"
                                                                        message:@"Saved the customer."
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
                [self.tableView reloadData];
            }
            
        } else if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Edit"]) {
            NSLog(@"Edit selected");
            [self.editBtn setTitle:@"Save" forState:UIControlStateNormal];
            [self.deleteBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            [self enableInteraction];
        }
        
    } else if (button.tag == 1) {
        if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Cancel"]) {
            
            if (self.newCustomer) {
                self.customer = nil;
                [[self navigationController] popViewControllerAnimated:YES];
            } else {
                [self disableInteraction];
                [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
                [self.deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
            }
            
            
        } else if ([[button titleForState:UIControlStateNormal] isEqualToString:@"Delete"]) {
            

        }
        
    }
}

// Very basic in app validation
- (BOOL)validateCustomer
{
    if (self.customerField.text.length > 0 &&
        self.contactField.text.length > 0 &&
        self.emailField.text.length > 0 &&
        self.phoneField.text.length > 0
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

// Method removes the keyboard when clicking on anything but the keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toTicketDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TicketDetailVC *destViewController = segue.destinationViewController;
        if (destViewController) {
            destViewController.ticket = [self.tableObjects objectAtIndex:indexPath.row];
        }
    } else if ([segue.identifier isEqualToString:@"toNewTicket"]) {
        [segue.destinationViewController setNewTicket:TRUE];
    }
}

@end
