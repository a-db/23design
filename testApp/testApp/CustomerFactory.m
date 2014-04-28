//
//  CustomerFactory.m
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "CustomerFactory.h"
#import "Customer.h"
#import <KinveyKit/KinveyKit.h>


@implementation CustomerFactory

// Create tickets in an empty DB
- (void)loadCustomers
{
    
    NSMutableArray *customerArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0, j = 10; i<j; i++) {
        Customer *customer = [[Customer alloc] init];
        customer.companyName = [NSString stringWithFormat:@"customer #%d", i+1];
        customer.contact = [NSString stringWithFormat:@"Contact #%d", i+1];
        customer.phone = [NSString stringWithFormat:@"%d%d%d-%d%d%d-%d%d%d%d",i+1,i+1,i+1,i+1,i+1,i+1,i+1,i+1,i+1,i+1];
        customer.email = [NSString stringWithFormat:@"email#%d@test.biz",i+1];
        
        
        [customerArray addObject:customer];
    }
    
    KCSCollection *customers = [KCSCollection collectionFromString:@"customers" ofClass:[Customer class]];
    KCSLinkedAppdataStore *store = [KCSLinkedAppdataStore storeWithCollection:customers options:nil];
    
    [store countWithBlock:^(unsigned long count, NSError *errorOrNil) {
        NSLog(@"There are %ld elements", count);
        if (count <= 1) {
            [store saveObject:customerArray withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil == nil && objectsOrNil != nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save worked!"
                                                                    message:@"Saved the customer"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                    [store countWithBlock:^(unsigned long count, NSError *errorOrNil) {
                        NSLog(@"There are %ld elements", count);
                    }];
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
