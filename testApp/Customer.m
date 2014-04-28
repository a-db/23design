//
//  Customer.m
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "Customer.h"
#import "Ticket.h"

@implementation Customer

- (id)init
{
    self = [super init];
    if (self) {
        self.companyName = @"";
        self.contact = @"";
        self.email = @"";
        self.phone = @"";
        self.tickets = [NSMutableArray array];
    }
    return self;
}

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId" : KCSEntityKeyId, //the required _id field
             @"companyName":@"companyName",
             @"contact":@"contact",
             @"email":@"email",
             @"phone":@"phone",
             @"tickets":@"tickets"
             };
}

+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"tickets" /* backend field name */ : @"tickets" /* collection name */};
}

// Map tickets to a ticket object
+(NSDictionary *)kinveyObjectBuilderOptions
{
    // reference class map - maps properties to objects
    return @{ KCS_REFERENCE_MAP_KEY : @{ @"tickets" : [Ticket class]}};
}


@end
