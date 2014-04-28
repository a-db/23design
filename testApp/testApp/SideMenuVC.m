//
//  SideMenuVC.m
//  testApp
//
//  Created by Aaron Burke on 10/8/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "SideMenuVC.h"
#import "SideMenuCell.h"
#import <KinveyKit/KinveyKit.h>


@interface SideMenuVC ()

@end

@implementation SideMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Menu";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SideMenuCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"changePW"];
        if (cell1) {
            
            [cell1 createCell:indexPath.row];
            
            return cell1;
        }
    } else if (indexPath.row == 1) {
        SideMenuCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"logout"];
        if (cell2) {
            
            [cell2 createCell:indexPath.row];
            
            return cell2;
        }

    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"changePW" sender:nil]; 
    } else if (indexPath.row == 1) {
        [[KCSUser activeUser] logout];
        [self performSegueWithIdentifier:@"logout" sender:nil];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

@end

