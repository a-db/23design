//
//  LoginViewController.m
//  testApp
//
//  Created by Aaron Burke on 10/7/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import <KinveyKit/KinveyKit.h>
#import "AppDelegate.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *patternImage = [UIImage imageNamed:@"grey_@2X.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    
    // Kinvey-Use code: if the user is already logged in, go straight to the main part of the app via segue
    if ([KCSUser hasSavedCredentials] == YES) {
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) validate
{
    self.loginButton.enabled = self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self validate];
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self validate];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self validate];
    if (textField == self.userNameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if (self.loginButton.enabled) {
            [self login:self.loginButton];
        }
    }
    return YES;
}

- (void) handeLogin:(NSError*)errorOrNil
{
    if (errorOrNil != nil) {
        BOOL wasUserError = [[errorOrNil domain] isEqual:KCSUserErrorDomain];
        NSString* title = wasUserError ? NSLocalizedString(@"Invalid Credentials", @"credentials error title") : NSLocalizedString(@"An error occurred.", @"Generic error message");
        NSString* message = wasUserError ? NSLocalizedString(@"Wrong username or password. Please check and try again.", @"credentials error message") : [errorOrNil localizedDescription];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // Clear fields on success
        self.userNameTextField.text = @"";
        self.passwordTextField.text = @"";
        // Login in went okay - go to the table
        [self performSegueWithIdentifier:@"toMain" sender:self];
    }
    
}

- (IBAction)login:(id)sender
{
    
    // Kinvey-Use code: login with the typed credentials
    [KCSUser loginWithUsername:self.userNameTextField.text password:self.passwordTextField.text withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        [self handeLogin:errorOrNil];
    }];
}



@end
