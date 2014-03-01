//
//  NearestStopsViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface NearestStopsViewController : UIViewController <MKMapViewDelegate, UITextViewDelegate, UISearchBarDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate> {
    
    CLGeocoder *_geocoder;
    
}



@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locationData;




@end
