//
//  BusStopAnnotation.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "BusStopAnnotation.h"

@implementation BusStopAnnotation

- (id)initWithName:(NSString *)commonName landmark:(NSString *)landmark coordinate:(CLLocationCoordinate2D)coordinate sourceData:(BusStopLocation*)data {
    
     if ((self = [super init])) {
         _commonName = [commonName copy];
         _landMark = [landmark copy];
         _locationObject = data;
         _coordinate = coordinate;
     }
    return self;
}

- (NSString *)title {
    return _commonName;
}

- (NSString *)subtitle {
    return _landMark;
}


@end
