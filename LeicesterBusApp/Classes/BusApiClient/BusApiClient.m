//
//  PISAPIClient.m
//  HSEAudit
//
//  Created by Aaron Wardle on 24/07/2013.
//  Copyright (c) 2013 spcs. All rights reserved.
//

#import "BusApiClient.h"
#import "AFNetworking.h"
#import "Reachability.h"

#include <CommonCrypto/CommonDigest.h>

#define APIToken @"1234abcd"
#define kAPIPath @"stops"
#define kBaseURL @"http://www.vivait.co.uk/LeicesterTransportAPI/web/api/0.1/"

@implementation BusApiClient

@synthesize user;

+ (id)sharedInstance {
    static BusApiClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[BusApiClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self setDefaultHeader:@"x-api-token" value:APIToken];
        [self setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

-(BOOL)isAuthorized {
    
    return [[user objectForKey:@"id"] intValue]>0;
}


- (BOOL)isNetworkAvailable {
    
    Reachability *curReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

-(void)commandWithParams:(NSMutableDictionary *)params apiURL:(NSString *)apiURL onCompletion:(JSONResponseBlock)completionBlock onFailure:(JSONResponseBlock)failureBlock {
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
   
    NSMutableURLRequest *apiRequest = [httpClient requestWithMethod:@"GET" path:apiURL parameters:params];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:apiRequest];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
    
}




@end
