//
//  Ticket.h
//  testApp
//
//  Created by Aaron Burke on 10/9/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
#import "Customer.h"

@interface Ticket : NSObject <KCSPersistable>

// Ticket properties to be stored with each ticket
@property (nonatomic, strong) NSString* entityId; //Kinvey entity _id
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Customer *customer;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, strong) NSDate *shipDate;
@property (nonatomic, strong) NSString *billAddress;
@property (nonatomic, strong) NSNumber *terms;
@property (nonatomic, strong) NSNumber *ticketNumber;
@property (nonatomic, strong) NSString *shipAddress;
@property (nonatomic, strong) NSString *salesman;
// printer = 0-2 for valid values
@property (nonatomic, strong) NSNumber *printer;
@property (nonatomic, strong) NSString *jobDescription;
@property (nonatomic, strong) NSNumber *quantity;
@property (nonatomic, strong) NSString *material;
@property (nonatomic, strong) NSString *finishing;
// status = 0-4 for valid values
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) KCSMetadata *metaData;


@end
