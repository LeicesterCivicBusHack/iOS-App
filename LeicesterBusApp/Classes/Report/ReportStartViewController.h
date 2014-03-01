//
//  ReportStartViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface ReportStartViewController : UIViewController {
    CLGeocoder *_gecoder;
}

@property (nonatomic, strong) CLGeocoder *geocoder;

-(IBAction)btnStop:(id)sender;


@end
