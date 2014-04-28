//
//  CustomersVC.m
//  testApp
//
//  Created by Aaron Burke on 10/9/13.
//  Copyright (c) 2013 Aaron Burke. All rights reserved.
//

#import "CustomersVC.h"
#import "Customer.h"
#import "CustomerTableCell.h"
#import "CustomerDetailVC.h"
#import <KinveyKit/KinveyKit.h>

@interface CustomersVC ()

@property (nonatomic, strong) NSArray* tableObjects;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UILabel *customersLabel;
@property (strong, nonatomic) IBOutlet UILabel *customerNewLabel;
@property (strong, nonatomic) IBOutlet UIButton *customerBtn;

@end

@implementation CustomersVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"DID LOAD");
    
    self.searchDisplayController.searchBar.translucent = YES;
    
    KCSCollection *customers = [KCSCollection collectionFromString:@"customers" ofClass:[Customer class]];
    KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:customers options:nil];
    
    KCSQuery* query = [KCSQuery query];
    KCSQuerySortModifier* nameSort = [[KCSQuerySortModifier alloc] initWithField:@"companyName" inDirection:kKCSAscending];
    [query addSortModifier:nameSort];
    
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
    
    self.searchResults = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    // Query DB and return all customers for table
    KCSCollection *customers = [KCSCollection collectionFromString:@"customers" ofClass:[Customer class]];
    KCSLinkedAppdataStore  *store = [KCSLinkedAppdataStore  storeWithCollection:customers options:nil];
    
    KCSQuery* query = [KCSQuery query];
    KCSQuerySortModifier* nameSort = [[KCSQuerySortModifier alloc] initWithField:@"companyName" inDirection:kKCSAscending];
    [query addSortModifier:nameSort];
    
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    } else {
        return self.tableObjects.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdent = @"customerCell";
    CustomerTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdent];
    
    if (!cell) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdent];
    }
    
        
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [cell createCell:[self.searchResults objectAtIndex:indexPath.row]];
    } else {
        [cell createCell:[self.tableObjects objectAtIndex:indexPath.row]];
    }
    
    cell.bgImgView.layer.cornerRadius = 8;
    cell.bgImgView.layer.shouldRasterize = YES;
    cell.bgImgViewShadow.layer.cornerRadius = 8;
    cell.bgImgViewShadow.layer.shouldRasterize = YES;
    
    return cell;
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


#pragma mark Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.searchResults removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.companyName contains[c] %@",searchText];
    self.searchResults = [NSMutableArray arrayWithArray:[self.tableObjects filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    // Edit the tableview shown by the search display controller
    self.searchDisplayController.searchResultsTableView.rowHeight = 84;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Effort to make the searchbar behave with specific positioning
    self.searchDisplayController.searchBar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 50);
    
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    // Effort to make the searchbar behave with specific positioning
    self.searchDisplayController.searchBar.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 50);
    self.searchDisplayController.searchResultsTableView.frame = CGRectMake(15, 0, self.view.frame.size.width, self.view.frame.size.height);

    
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    // Hide when searchbar is active
    self.customersLabel.hidden = FALSE;
    self.customerNewLabel.hidden = FALSE;
    self.customerBtn.hidden = FALSE;
    
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    // Unhide when searchbar is not active
    self.customersLabel.hidden = TRUE;
    self.customerNewLabel.hidden = TRUE;
    self.customerBtn.hidden = TRUE;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toCustomerDetail"]) {
        if (self.searchDisplayController.active) {
            CustomerDetailVC *destViewController = segue.destinationViewController;
            if (destViewController) {
                destViewController.customer = [self.searchResults objectAtIndex:self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow.row];
            }
        } else {
            CustomerDetailVC *destViewController = segue.destinationViewController;
            if (destViewController) {
                destViewController.customer = [self.tableObjects objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            }
        }
    } else if ([segue.identifier isEqualToString:@"toNewCustomer"]) {
        CustomerDetailVC *destViewController = segue.destinationViewController;
        if (destViewController) {
            [segue.destinationViewController setNewCustomer:TRUE];
        }
    }
}

@end