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
#define kAPIPath @"stops.js"
#define kBaseURL @"https://mistabus.subora.com:3000/"

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

-(void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock onFailure:(JSONResponseBlock)failureBlock {
    
    NSData* uploadFile = nil;
    if ([params objectForKey:@"file"]) {
        uploadFile = (NSData*)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    
    
    NSMutableURLRequest *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:kAPIPath parameters:params
               constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
                   if (uploadFile) {
                       [formData appendPartWithFileData:uploadFile
                                                   name:@"file"
                                               fileName:@"photo.jpg"
                                               mimeType:@"image/jpeg"];
                   }
               }];
    
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        failureBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
        //        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
    
}


-(void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock
{
    NSData* uploadFile = nil;
    if ([params objectForKey:@"file"]) {
        uploadFile = (NSData*)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    
    /*
     Attach the MD5 Key which was captured during login
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [defaults objectForKey:@"key"];
    
    if ([key length] != 0) {
        [params setObject:key forKey:@"key"];
    }
    
    NSMutableURLRequest *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:kAPIPath parameters:params
               constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
                   if (uploadFile) {
                       [formData appendPartWithFileData:uploadFile
                                                   name:@"user_file"
                                               fileName:@"photo.jpg"
                                               mimeType:@"image/jpeg"];
                   }
               }];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
    
}

@end
