//
//  SideMenuCell.h
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;

- (void)createCell:(int)index;

@end
