//
//  TicketsVC.m
//  testApp
//
//  Created by Aaron Burke on 10/8/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "TicketsVC.h"
#import "Ticket.h"
#import "TicketTableCell.h"
#import "TicketDetailVC.h"
#import <KinveyKit/KinveyKit.h>

@interface TicketsVC ()

@property (nonatomic, strong) NSArray* tableObjects;

@end

@implementation TicketsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Get all tickets and sort them by ticket number
    KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
    KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:tickets options:nil];
    
    KCSQuery* query = [KCSQuery query];
    KCSQuerySortModifier* dateSort = [[KCSQuerySortModifier alloc] initWithField:@"ticketNumber" inDirection:kKCSDescending];
    [query addSortModifier:dateSort];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            self.tableObjects = objectsOrNil;
            [self.tableView reloadData];
        }
    } withProgressBlock:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Get all tickets and sort them by ticket number on every reload of the view
    KCSCollection *tickets = [KCSCollection collectionFromString:@"tickets" ofClass:[Ticket class]];
    KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:tickets options:nil];
    
    KCSQuery* query = [KCSQuery query];
    KCSQuerySortModifier* dateSort = [[KCSQuerySortModifier alloc] initWithField:@"ticketNumber" inDirection:kKCSDescending];
    [query addSortModifier:dateSort];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            self.tableObjects = objectsOrNil;
            [self.tableView reloadData];
        }
    } withProgressBlock:nil];
    
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
    return self.tableObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ticketCell"];
    if (cell) {
        
        [cell createCell:[self.tableObjects objectAtIndex:indexPath.row]];
        
        cell.bgImgView.layer.cornerRadius = 8;
        cell.bgImgView.layer.shouldRasterize = YES;
        cell.bgImgViewShadow.layer.cornerRadius = 8;
        cell.bgImgViewShadow.layer.shouldRasterize = YES;
        
        return cell;
    }
    return nil;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toTicketDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TicketDetailVC *destViewController = segue.destinationViewController;
        if (destViewController) {
            destViewController.ticket = [self.tableObjects objectAtIndex:indexPath.row];
        }
    } else if ([segue.identifier isEqualToString:@"toNewTicket"]) {
        [segue.destinationViewController setNewTicket:TRUE];
    }
}


@end
