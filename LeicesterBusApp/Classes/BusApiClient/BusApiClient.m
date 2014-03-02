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
#define kBaseURL @"http://mistabus.subora.com:3000/"

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
        ///NSLog(@"Not Reachable");
        return NO;
    } else {
        //NSLog(@"Reachable");
        return YES;
    }
}

-(void)commandWithParams:(NSMutableDictionary *)params apiURL:(NSString *)apiURL onCompletion:(JSONResponseBlock)completionBlock onFailure:(JSONResponseBlock)failureBlock {
    
//    NSData* uploadFile = nil;
//    if ([params objectForKey:@"file"]) {
//        uploadFile = (NSData*)[params objectForKey:@"file"];
//        [params removeObjectForKey:@"file"];
//    }
//    
//    
//    NSMutableURLRequest *apiRequest =
//    [self multipartFormRequestWithMethod:@"POST"
//                                    path:kAPIPath parameters:params
//               constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
//                   if (uploadFile) {
//                       [formData appendPartWithFileData:uploadFile
//                                                   name:@"file"
//                                               fileName:@"photo.jpg"
//                                               mimeType:@"image/jpeg"];
//                   }
//               }];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    
    NSMutableURLRequest *apiRequest = [httpClient requestWithMethod:@"GET" path:apiURL parameters:params];
    
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
    
}




@end
