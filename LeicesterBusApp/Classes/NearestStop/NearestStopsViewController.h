//
//  NearestStopsViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusStopLocation.h"

@protocol SelectBusStopDelegate <NSObject>

- (void)getSelectedBusLocation:(BusStopLocation *)busStopLocation;

@end

@interface NearestStopsViewController : UIViewController <MKMapViewDelegate, UITextViewDelegate, UISearchBarDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate> {
    
    CLGeocoder *_geocoder;
    
}


@property (nonatomic, weak)id<SelectBusStopDelegate> delegate;

@property (nonatomic, strong) BusStopLocation *selectedLocation;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locationData;
@property (nonatomic) BOOL isAChildView;
@property (nonatomic) BOOL isAccessedViaReportView;


@end
