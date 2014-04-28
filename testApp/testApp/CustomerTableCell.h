//
//  CustomerTableCell.h
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@interface CustomerTableCell : UITableViewCell


// Cell outlets
@property (strong, nonatomic) IBOutlet UILabel *customerName;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgViewShadow;
@property (strong, nonatomic) IBOutlet UIImageView *bgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *customerImg;
@property (strong, nonatomic) IBOutlet UILabel *phoneLbl;
@property (strong, nonatomic) IBOutlet UILabel *ticketsNumLbl;

// Creates the cell with the specific customer object
- (void)createCell:(Customer*)customerInfo;

@end
