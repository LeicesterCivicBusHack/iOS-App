//
//  RoutesMenuViewController.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "RoutesMenuViewController.h"
#import "RoutesWebViewController.h"
#import "MenuViewController.h"
#import "MMDrawerBarButtonItem.h"

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
    
    if (!_isAChildView) {
        [self setupLeftMenuButton];
    }
    
}


#pragma mark - Left Menu Set-up
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


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
    
    cell.textLabel.text = routeCompany;
  
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
