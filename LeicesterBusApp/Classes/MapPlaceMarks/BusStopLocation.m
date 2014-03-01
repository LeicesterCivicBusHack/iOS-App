//
//  BusStopLocation.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "BusStopLocation.h"
#import "NSDictionary+Utility.h"

@implementation BusStopLocation

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
 
        _commonName = [dictionary objectForKeyNotNull:@"CommonName"];
        _landMark = [dictionary objectForKeyNotNull:@"Landmark"];
        _longitude = [dictionary objectForKeyNotNull:@"Latitude"];
        _latitude = [dictionary objectForKeyNotNull:@"Longitude"];
        _distance = [dictionary objectForKeyNotNull:@"distance"];
    }
    
    return self;
}

@end
