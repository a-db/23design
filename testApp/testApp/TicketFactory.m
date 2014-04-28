//
//  TicketFactory.m
//  testApp
//
//  Created by Aaron Burke on 10/9/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "TicketFactory.h"
#import "Ticket.h"
#import "TicketsVC.h"
#import "Customer.h"
#import <KinveyKit/KinveyKit.h>

@interface TicketFactory ()

@property (nonatomic,strong) NSArray *customers;
@property (nonatomic,strong) NSMutableArray *ticketArray;

@end

@implementation TicketFactory


// Gather customers from DB
- (void)loadCustomers
{
    KCSCollection *customers = [KCSCollection collectionFromString:@"customers" ofClass:[Customer class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:customers options:nil];
    
    [store queryWithQuery:[KCSQuery query] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            self.customers = objectsOrNil;
            [self loadTickets];
        }
    } withProgressBlock:nil];
}

// Create tickets and associate to a customer
- (void)loadTickets
{
    self.ticketArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0, j = 10; i<j; i++) {
        
        Ticket *ticket = [[Ticket alloc] init];
        ticket.customer = self.customers[i];
        ticket.dueDate = [NSDate date];
        ticket.shipDate = [NSDate date];
        ticket.billAddress = @"Billing address line 1\nline 2\nline 3";
        ticket.terms = [NSNumber numberWithInt:i+1];
        ticket.ticketNumber = [NSNumber numberWithInt:i+1];
        ticket.shipAddress = @"Shipping address line 1\nline 2\nline 3";
        ticket.salesman = @"Test Salesman";
        ticket.printer = [NSNumber numberWithInt:arc4random_uniform(3)];
        ticket.jobDescription = @"Job Description test line 1\nline 2\nline 3";
        ticket.quantity = [NSNumber numberWithInt:arc4random_uniform(5000)];
        ticket.material = @"Material field test";
        ticket.finishing = @"Finishing test line 1\nline 2\nline 3";
        ticket.status = [NSNumber numberWithInt:arc4random_uniform(5)];
        [self.ticketArray addObject:ticket];
    }
    
    KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
    KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:tickets options:nil];
    
    [store countWithBlock:^(unsigned long count, NSError *errorOrNil) {
        NSLog(@"There are %ld elements", count);
        if (count <= 1) {
            [store saveObject:self.ticketArray withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
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
        }
    }];
    
    
    
}


@end
