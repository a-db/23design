//
//  LoginViewController.h
//  testApp
//
//  Created by Aaron Burke on 10/7/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

@interface LoginViewController : UIViewController <UITextFieldDelegate>

// Login outlets
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)login:(id)sender;

@end
