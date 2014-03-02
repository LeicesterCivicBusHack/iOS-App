//
//  BusStopLocation.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopLocation : NSObject


@property (weak, readonly) NSString *commonName;
@property (weak, readonly) NSString *landMark;
@property (weak, readonly) NSString *latitude;
@property (weak, readonly) NSString *longitude;
@property (weak, readonly) NSString *distance;
@property (weak, readonly) NSString *locationID;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
