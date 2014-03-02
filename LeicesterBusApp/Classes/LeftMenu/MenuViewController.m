//
//  MenuViewController.m
//
//  Created by Aaron Wardle on 13/02/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "MenuViewController.h"
#import "NewsViewController.h"
#import "AboutViewController.h"
#import "MMNavigationController.h"
#import "HomeScreenViewController.h"
#import "NearestStopsViewController.h"
#import "RoutesMenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    
    
    UIColor *tableViewBackgroundColor = [UIColor colorWithRed:226.0/255.0
                                               green:227.0/255.0
                                                blue:227.0/255.0
                                               alpha:1.0];
    
    
    [self.tableView setBackgroundColor:tableViewBackgroundColor];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:223.0/255.0 green:222.0/255.0 blue:224.0/255.0 alpha:1.0]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    
    NSDictionary *navBarTitleDict;
    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
                                           green:70.0/255.0
                                            blue:77.0/255.0
                                           alpha:1.0];
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
  
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
    
    self.arrayOptions = @[@"Home", @"Nearest Stop", @"Report Late Bus", @"Bus Routes", @"About"];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayOptions count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    NSString *text = [_arrayOptions objectAtIndex:indexPath.row];
    
    
    UIColor *tableViewBackgroundColor;
    tableViewBackgroundColor = [UIColor colorWithRed:232.0/255.0
                                               green:231.0/255.0
                                                blue:232.0/255.0
                                               alpha:1.0];
    
    
    cell.backgroundColor = tableViewBackgroundColor;
    
    cell.textLabel.font = [UIFont fontWithName:@"PT Sans" size:16];
    UIImage *image;

    image = [UIImage imageNamed:@"temp_icon"];
    
    cell.imageView.image = image;
    cell.textLabel.text = text;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    //self.arrayOptions = @[@"Home", @"Nearest Stop", @"Report Late Bus", @"Bus Routes", @"About"];
    UIViewController *vc;
    switch (indexPath.row) {
        case 0: // Home
        {
            vc = [[HomeScreenViewController alloc] initWithNibName:@"HomeScreenViewController" bundle:nil];
        }
            break;
        case 1:  // Nearest Stop
        {
            vc = [[NearestStopsViewController alloc] initWithNibName:@"NearestStopsViewController" bundle:nil];
        }
            break;
            
        case 2:     // Report Late Bus
        {
            UIStoryboard *reportStoryBoard = [UIStoryboard storyboardWithName:@"ReportStoryboard" bundle:nil];
            vc = [reportStoryBoard instantiateInitialViewController];
            
            //[self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 3:     // Routes
        {
            vc = [[RoutesMenuViewController alloc] initWithNibName:@"RoutesMenuViewController" bundle:nil];
            
        }
            
            break;
        case 4:     // About Ciew
        {
            vc = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        }
            break;
            
            
            
        default:
            break;
    }
    
    
    // Check if the VC is not nil
    if (vc != nil) {
        // Switch the centre View
        
        MMNavigationController *nav = [[MMNavigationController alloc] initWithRootViewController:vc];
        nav.navigationBar.translucent = NO;
        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
