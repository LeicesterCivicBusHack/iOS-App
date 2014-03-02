//
//  BusStopAnnotation.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BusStopLocation.h"

@interface BusStopAnnotation : NSObject <MKAnnotation>

@property (copy) NSString *commonName;
@property (copy) NSString *landMark;


@property (nonatomic, strong) BusStopLocation *locationObject;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString *)commonName landmark:(NSString *)landmark coordinate:(CLLocationCoordinate2D)coordinate sourceData:(BusStopLocation*)data;



@end
