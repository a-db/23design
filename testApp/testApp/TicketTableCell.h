//
//  TicketTableCell.h
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

@interface TicketTableCell : UITableViewCell

// Outlets for cell
@property (strong, nonatomic) IBOutlet UILabel *ticketNum;
@property (strong, nonatomic) IBOutlet UILabel *customerName;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgViewShadow;
@property (strong, nonatomic) IBOutlet UIImageView *printerImg;
@property (strong, nonatomic) IBOutlet UILabel *dueDate;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;


// Method to create the cell
- (void)createCell:(Ticket*)ticketInfo;

@end
