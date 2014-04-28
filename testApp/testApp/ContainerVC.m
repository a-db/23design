//
//  ContainerVC.m
//  testApp
//
//  Created by Aaron Burke on 10/8/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "ContainerVC.h"
#import "TicketsVC.h"
#import "CustomersVC.h"

// Defines views within the container
#define SegueIdentifierTicket @"ticketList"
#define SegueIdentifierCustomer @"customerList"

@interface ContainerVC ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) TicketsVC *ticketsVC;
@property (strong, nonatomic) CustomersVC *customersVC;

// Keeps up with an existing transition
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation ContainerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierTicket;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if (([segue.identifier isEqualToString:SegueIdentifierTicket]) && !self.ticketsVC) {
        self.ticketsVC = segue.destinationViewController;
    }
    
    if (([segue.identifier isEqualToString:SegueIdentifierCustomer]) && !self.customersVC) {
        self.customersVC = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierTicket]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.ticketsVC];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            ((UIViewController *)segue.destinationViewController).view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:((UIViewController *)segue.destinationViewController).view];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierCustomer]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.customersVC];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierTicket]) ? SegueIdentifierCustomer : SegueIdentifierTicket;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

@end
