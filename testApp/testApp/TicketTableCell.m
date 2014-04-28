//
//  TicketTableCell.m
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "TicketTableCell.h"
#import <KinveyKit/KinveyKit.h>

@implementation TicketTableCell

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

    // Configure the view for the selected state
}

- (void)createCell:(Ticket*)ticketInfo
{
    UIImage *flatbedImg = [UIImage imageNamed:@"cyan-flatbed.png"];
    UIImage *hpImg = [UIImage imageNamed:@"lime-hp.png"];
    UIImage *rolandImg = [UIImage imageNamed:@"magenta-roland.png"];
    
    Customer *currentCustomer = ticketInfo.customer;
    self.ticketNum.text = [NSString stringWithFormat:@"%@", ticketInfo.ticketNumber];
    self.customerName.text = [currentCustomer valueForKey:@"companyName"];
    
    NSDate *date = [ticketInfo valueForKey:@"dueDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.dueDate.text = [dateFormatter stringFromDate:date];
    
    if ([[ticketInfo valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithInteger:0]]) {
        self.statusLbl.text = @"PrePress";
    } else if ([[ticketInfo valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
        self.statusLbl.text = @"Printing";
    } else if ([[ticketInfo valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithInteger:2]]) {
        self.statusLbl.text = @"PostPress";
    } else if ([[ticketInfo valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithInteger:3]]) {
        self.statusLbl.text = @"Completed";
    } else if ([[ticketInfo valueForKey:@"status"] isEqualToNumber:[NSNumber numberWithInteger:4]]) {
        self.statusLbl.text = @"Shipped";
    }
    
    
    if ([[ticketInfo valueForKey:@"printer"] isEqualToNumber:[NSNumber numberWithInteger:0]]) {
        self.printerImg.image = flatbedImg;
    } else if ([[ticketInfo valueForKey:@"printer"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
        self.printerImg.image = rolandImg;
    } else if ([[ticketInfo valueForKey:@"printer"] isEqualToNumber:[NSNumber numberWithInteger:2]]) {
        self.printerImg.image = hpImg;
    }
    
}

@end
