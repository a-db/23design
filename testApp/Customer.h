//
//  Customer.h
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface Customer : NSObject <KCSPersistable>

// Customer properties to be stored with each customer
@property (nonatomic, strong) NSString* entityId; //Kinvey entity _id
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSMutableArray *tickets;

@end
