//
//  HomeScreenViewController.m
//
//  Created by Aaron Wardle on 13/02/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "MenuViewController.h"
#import "MMDrawerBarButtonItem.h"

#import "RoutesMenuViewController.h"


@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

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
    // Do any additional setup after loading the view from its nib.
    
    
    [self setupLeftMenuButton];
}


-(IBAction)btnReport:(id)sender {
    UIStoryboard *reportStoryBoard = [UIStoryboard storyboardWithName:@"ReportStoryboard" bundle:nil];
    UIViewController *vc = [reportStoryBoard instantiateInitialViewController];

    [self.navigationController pushViewController:vc animated:YES];
    
}
-(IBAction)btnHistory:(id)sender {
    
}


-(IBAction)btnRoutes:(id)sender {
    RoutesMenuViewController *vc = [[RoutesMenuViewController alloc] initWithNibName:@"RoutesMenuViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
