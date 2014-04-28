//
//  ChangePasswordVC.m
//  testApp
//
//  Created by Aaron Burke on 10/10/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "ChangePasswordVC.h"
#import <KinveyKit/KinveyKit.h>

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *patternImage = [UIImage imageNamed:@"grey_@2X.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClick:(UIButton*)button
{
    if (button.tag == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (button.tag == 1) {
        NSLog(@"Pass= %@ - Conf= %@", self.password.text, self.confirmPW.text);
        if (![self.password.text isEqualToString:self.confirmPW.text]) {
            NSString* title = NSLocalizedString(@"Password Error", @"Password Error");
            NSString* message = NSLocalizedString(@"Passwords do not match or the password has already been used.", @"credentials error message");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            KCSUser* activeUser = [KCSUser activeUser];
            
            [activeUser saveWithCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil != nil) {
                    NSLog(@"error %@ when changing password", errorOrNil);
                } else {
                    NSLog(@"password changed");
                    NSString* title = NSLocalizedString(@"Success", @"Success");
                    NSString* message = NSLocalizedString(@"Password has been changed.", @"credentials change message");
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            } ];
        }
    }
}

@end
