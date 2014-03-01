//
//  ReportStartViewController.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "ReportStartViewController.h"
#import <MapKit/MapKit.h>
#import "BusApiClient.h"


@interface ReportStartViewController ()

@end

@implementation ReportStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - 
- (void)sendReport {
    
   
    
    
    if ([[BusApiClient sharedInstance] isNetworkAvailable]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"nearest",@"command",
                                       @"-1.150311", @"long",
                                       @"52.630365", @"lat", nil];
        
        NSLog(@"Params %@", params);
        
        [[BusApiClient sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
            NSLog(@"Json Response %@", json);
        }];
    }
    
    
    
}


-(IBAction)btnStop:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self sendReport];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
