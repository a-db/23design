//
//  CustomerTableCell.m
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "CustomerTableCell.h"
#import "Ticket.h"
#import <KinveyKit/KinveyKit.h>

@implementation CustomerTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


- (void)createCell:(Customer*)customerInfo
{
    // Create cell text
    self.customerName.text = customerInfo.companyName;
    UIImage *customerIcon = [UIImage imageNamed:@"customer-icon.png"];
    self.customerImg.image = customerIcon;
    self.phoneLbl.text = [customerInfo valueForKey:@"phone"];
    
    // Load tickets associated with customer to get the ticket count
    KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
    KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:tickets options:nil];
    
    NSString *customerId = customerInfo.kinveyObjectId;
    
    KCSQuery *query = [KCSQuery queryOnField:@"customer._id" withExactMatchForValue:customerId];
    KCSQuerySortModifier* dateSort = [[KCSQuerySortModifier alloc] initWithField:@"ticketNumber" inDirection:kKCSDescending];
    [query addSortModifier:dateSort];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            self.ticketsNumLbl.text = [NSString stringWithFormat:@"%d", objectsOrNil.count];
        }
    } withProgressBlock:nil];
    
}



@end
