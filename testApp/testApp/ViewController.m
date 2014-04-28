//
//  ViewController.m
//  testApp
//
//  Created by Aaron Burke on 10/7/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "ContainerVC.h"
#import <QuartzCore/QuartzCore.h>

#import "TicketFactory.h"
#import "CustomerFactory.h"

@interface ViewController () 

// View management
@property (nonatomic, weak) ContainerVC *containerViewController;
@property (strong, nonatomic) IBOutlet UIView *viewForContainer;

// Button state
@property (nonatomic, assign) ButtonState button;

// Button Effect Usage
@property (strong, nonatomic) IBOutlet UILabel *ticketLbl;
@property (strong, nonatomic) IBOutlet UILabel *customerLbl;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    
    // Used to load tickets when needed
//    TicketFactory *testInfo = [[TicketFactory alloc] init];
//    [testInfo loadCustomers];
//    CustomerFactory *testCustomers = [[CustomerFactory alloc] init];
//    [testCustomers loadCustomers];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.navigationItem.rightBarButtonItem.title = [dateFormatter stringFromDate:date];
    
    UIImage *patternImage = [UIImage imageNamed:@"grey_@2X.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.button = ticket_on;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.sidebarButton.target = self.revealViewController;
    self.sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Setup the container view properties
    self.viewForContainer.layer.cornerRadius = 8;
    self.viewForContainer.layer.masksToBounds = NO;
    self.viewForContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewForContainer.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewForContainer.layer.shadowOpacity = 0.2;
    self.viewForContainer.layer.shadowRadius = 3.0;
    // Setup the ticket button properties
    self.ticketBtn.layer.cornerRadius = 8;
    self.ticketBtn.layer.masksToBounds = NO;
    self.ticketBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ticketBtn.layer.shadowOffset = CGSizeMake(0, 0);
    self.ticketBtn.layer.shadowOpacity = 0.2;
    self.ticketBtn.layer.shadowRadius = 3.0;
    // Setup the customer button properties
    self.customerBtn.layer.cornerRadius = 8;
    self.customerBtn.layer.masksToBounds = NO;
    self.customerBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.customerBtn.layer.shadowOffset = CGSizeMake(0, 0);
    self.customerBtn.layer.shadowOpacity = 0.2;
    self.customerBtn.layer.shadowRadius = 3.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerViewController = segue.destinationViewController;
    }
}

// Controls visual and state of buttons and transition to new view in container
- (IBAction)onClick:(UIButton*)button
{
    if (button.tag == 0 && self.button == ticket_on) {
        self.ticketBtn.backgroundColor = [UIColor whiteColor];
        self.ticketLbl.backgroundColor = [UIColor whiteColor];
        self.customerBtn.backgroundColor = [UIColor clearColor];
        self.customerLbl.backgroundColor = [UIColor clearColor];
    } else if (button.tag == 0 && self.button == customer_on) {
        [self.containerViewController swapViewControllers];
        self.button = ticket_on;
        self.ticketBtn.backgroundColor = [UIColor whiteColor];
        self.ticketLbl.backgroundColor = [UIColor whiteColor];
        self.customerBtn.backgroundColor = [UIColor clearColor];
        self.customerLbl.backgroundColor = [UIColor clearColor];
    }
    
    if (button.tag == 1 && self.button == customer_on) {
        self.ticketBtn.backgroundColor = [UIColor clearColor];
        self.ticketLbl.backgroundColor = [UIColor clearColor];
        self.customerBtn.backgroundColor = [UIColor whiteColor];
        self.customerLbl.backgroundColor = [UIColor whiteColor];
    } else if (button.tag == 1 && self.button == ticket_on) {
        [self.containerViewController swapViewControllers];
        self.button = customer_on;
        self.ticketBtn.backgroundColor = [UIColor clearColor];
        self.ticketLbl.backgroundColor = [UIColor clearColor];
        self.customerBtn.backgroundColor = [UIColor whiteColor];
        self.customerLbl.backgroundColor = [UIColor whiteColor];
    }
    
}

@end
