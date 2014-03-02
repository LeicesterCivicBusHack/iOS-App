//
//  ReportStartViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ReportStartViewController : UIViewController

@property (nonatomic, strong) NSString *routeNumber;
@property (nonatomic, strong) NSString *busCompany;
@property (nonatomic, strong) NSString *expectedTime;
@property (assign) CGFloat longitude;
@property (assign) CGFloat latitude;



-(IBAction)btnStop:(id)sender;


@end
