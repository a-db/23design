//
//  ChangePasswordVC.h
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordVC : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *confirmPW;
@property (strong, nonatomic) IBOutlet UIButton *close;
@property (strong, nonatomic) IBOutlet UIButton *change;


@end
