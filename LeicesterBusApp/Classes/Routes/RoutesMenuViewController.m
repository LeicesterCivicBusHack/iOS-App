//
//  RoutesMenuViewController.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "RoutesMenuViewController.h"
#import "RoutesWebViewController.h"


@interface RoutesMenuViewController ()

@end

@implementation RoutesMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Routes";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _arrayRoutes = [[NSArray alloc] initWithObjects:@"Arriva", @"First Bus", nil];
    _arrayURLS = [[NSArray alloc] initWithObjects:@"http://arrivabus.mobi/mobile", @"http://www.firstgroup.com/ukbus/leicester", nil];
}


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
    return [_arrayRoutes count];   // Change this to the array count
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
    
    NSString *routeCompany = [_arrayRoutes objectAtIndex:indexPath.row];
    
    // Custom Cell Code
    // ----------------------------------
    // CustomPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    // if (cell == nil) {
    //    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomPropertyCell" owner:self options:nil];
    //    Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    //    cell = [topLevelObjects objectAtIndex:0];
    //    cell = [[CustomPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"propertyCell"];
    // }
    
    cell.textLabel.text = routeCompany;
    //    cell.detailTextLabel.text = @"Detail Descrition goes here.";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Did Select Code to go here
    RoutesWebViewController *vc = [[RoutesWebViewController alloc] initWithNibName:@"RoutesWebViewController" bundle:nil];

    NSString *selectedCompany = [_arrayRoutes objectAtIndex:indexPath.row];
    vc.selectedCompany = selectedCompany;
    vc.selectedURL = [_arrayURLS objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
