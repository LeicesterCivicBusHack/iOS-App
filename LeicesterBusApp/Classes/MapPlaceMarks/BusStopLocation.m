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
 
        _commonName = [dictionary objectForKeyNotNull:@"name"];
        _landMark = [dictionary objectForKeyNotNull:@"locality"];
        _longitude = [dictionary objectForKeyNotNull:@"latitude"];
        _latitude = [dictionary objectForKeyNotNull:@"longitude"];
        _distance = [dictionary objectForKeyNotNull:@"distance"];
        _locationID = [dictionary objectForKeyNotNull:@"id"];
    }
    
    return self;
}

@end
