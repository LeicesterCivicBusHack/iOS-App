//
//  SelectCompanyTableViewController.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "SelectCompanyTableViewController.h"

@interface SelectCompanyTableViewController ()

@end

@implementation SelectCompanyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _arrayCompanies = @[@"Arriva", @"First Bus", @"Test Bus"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
//    
//    return 70;
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayCompanies count];   // Change this to the array count
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableViewCell";
    
    // Standard TableView Cell Code
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    
    // Custom Cell Code
    // ----------------------------------
    // CustomPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    // if (cell == nil) {
    //    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomPropertyCell" owner:self options:nil];
    //    Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    //    cell = [topLevelObjects objectAtIndex:0];
    //    cell = [[CustomPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"propertyCell"];
    // }
    
    NSString *companyName = [_arrayCompanies objectAtIndex:indexPath.row];
    if ([companyName isEqualToString:_selectedCompanyName]) {
        _lastSelectedIndex = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    cell.textLabel.text = companyName;
    return cell;
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_lastSelectedIndex) {
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:_lastSelectedIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    _lastSelectedIndex = indexPath;
    
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    [currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
 
    
    [self.delegate getSiteSelectedCompanyName:[_arrayCompanies objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];    
}


@end
