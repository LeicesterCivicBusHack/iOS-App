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
                                       
                                       _busStopLocation.locationID, @"loc", nil];
        
        
        [[BusApiClient sharedInstance] commandWithParams:params apiURL:@"postdelay.json"  onCompletion:^(NSDictionary *json) {
            
            NSString *delID = [json objectForKey:@"id"];
            _lblTrackingID.text = delID;
            
        } onFailure:^(NSDictionary *json) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error unable to submit data to web service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }];
    }    
}

-(IBAction)btnStillWaiting:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _lblTrackingID.text, @"del", nil];
    
    
    
    [[BusApiClient sharedInstance] commandWithParams:params apiURL:@"updatedelay.json"  onCompletion:^(NSDictionary *json) {
    } onFailure:^(NSDictionary *json) {
        NSLog(@"Error Received %@", json);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error unable to submit data to web service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

-(IBAction)btnBusArrived:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   
                                   _lblTrackingID.text, @"del",
                                   @"1", @"fin", nil];
    
    [[BusApiClient sharedInstance] commandWithParams:params apiURL:@"updatedelay.json"  onCompletion:^(NSDictionary *json) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks" message:@"Thanks for your report" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } onFailure:^(NSDictionary *json) {
        NSLog(@"Error Received %@", json);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error unable to submit data to web service." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }];

}




-(IBAction)btnStop:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    [self sendReport];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
