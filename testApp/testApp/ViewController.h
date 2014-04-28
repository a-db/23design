//
//  ViewController.h
//  testApp
//
//  Created by Aaron Burke on 10/7/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonState) {
    ticket_on,
    customer_on
};

@interface ViewController : UIViewController

// Buttons in the main view
@property (nonatomic, weak) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) IBOutlet UIButton *customerBtn;
@property (nonatomic, strong) IBOutlet UIButton *ticketBtn;

@end
