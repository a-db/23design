//
//  Ticket.m
//  testApp
//
//  Created by Aaron Burke on 10/9/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

- (id)init
{
    self = [super init];
    if (self) {
        self.date = [NSDate date];
        self.customer = nil;
        self.dueDate = nil;
        self.shipDate = nil;
        self.billAddress = @"";
        self.terms = 0;
        self.ticketNumber = 0;
        self.shipAddress = @"";
        self.salesman = @"";
        self.printer = nil;
        self.jobDescription = @"";
        self.quantity = 0;
        self.material = @"";
        self.finishing = @"";
        self.status = nil;
        self.metaData = nil;
    }
    return self;
}

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"date" : @"date",
             @"customer" : @"customer",
             @"dueDate" : @"dueDate",
             @"shipDate" : @"shipDate",
             @"billAddress" : @"billAddress",
             @"terms" : @"terms",
             @"ticketNumber" : @"ticketNumber",
             @"shipAddress" : @"shipAddress",
             @"salesman" : @"salesman",
             @"printer" : @"printer",
             @"jobDescription" : @"jobDescription",
             @"quantity" : @"quantity",
             @"material" : @"material",
             @"finishing" : @"finishing",
             @"status" : @"status",
             @"metaData" : KCSEntityKeyMetadata
             };
}

// Needed to map customer objects
+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"customer" : @"customers" };
}



@end
