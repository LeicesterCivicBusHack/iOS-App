//
//  BusApiClient.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//API call completion block with result as json
typedef void (^JSONResponseBlock)(NSDictionary* json);


@interface BusApiClient : AFHTTPClient

@property (strong, nonatomic) NSDictionary* user;

+ (id)sharedInstance;

-(BOOL)isAuthorized;

-(void)commandWithParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock;

-(void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock onFailure:(JSONResponseBlock)failureBlock;

-(BOOL)isNetworkAvailable;


@end
