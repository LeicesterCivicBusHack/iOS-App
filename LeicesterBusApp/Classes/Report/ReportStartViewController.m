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
    
   
    
    NSString *strLongitude = [NSString stringWithFormat:@"%f", _longitude];
    NSString *strLatitude = [NSString stringWithFormat:@"%f", _latitude];
    
    // mistabus.subora.com:3000/stops?latitude=52.630365&longitude=-1.150311
    
    if ([[BusApiClient sharedInstance] isNetworkAvailable]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       
                                       _busCompany, @"busCo",
                                       _routeNumber, @"routeNumber",
                                       _expectedTime, @"expectedTime",
                                       strLongitude, @"longitude",
                                       strLatitude, @"latitude", nil];
        
        NSLog(@"Params %@", params);
        
        
        [[BusApiClient sharedInstance] commandWithParams:params apiURL:@"http://mistabus.subora.com:3000/stops"  onCompletion:^(NSDictionary *json) {

            NSLog(@"API Response %@", json);
            
        } onFailure:^(NSDictionary *json) {
            NSLog(@"Error ");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error unable to submit data to web service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }];
    }    
}


-(IBAction)btnStop:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    NSLog(@"Bus Number = %@", _routeNumber);
    NSLog(@"Company Name = %@", _busCompany);
    NSLog(@"Longitude = %f", _longitude);
    NSLog(@"Latitude = %f", _latitude);
    NSLog(@"Expected Time %@", _expectedTime);
    
    [self sendReport];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
