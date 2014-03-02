//
//  ReportStartViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusStopLocation.h"



@interface ReportStartViewController : UIViewController

@property (nonatomic, strong) BusStopLocation *busStopLocation;
@property (nonatomic, strong) NSString *routeNumber;
@property (nonatomic, strong) NSString *busCompany;
@property (nonatomic, strong) NSString *expectedTime;
@property (nonatomic, weak) IBOutlet UILabel *lblTrackingID;

@property (assign) CGFloat longitude;
@property (assign) CGFloat latitude;



-(IBAction)btnStop:(id)sender;
-(IBAction)btnStillWaiting:(id)sender;
-(IBAction)btnBusArrived:(id)sender;

@end
