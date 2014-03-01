//
//  getNews.m
//  GMB
//
//  Created by Aaron Wardle on 06/01/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "getNews.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "NewsEntry.h"



@implementation getNews { }

void(^getServerResponseForUrlCallback)(BOOL success, NSDictionary *response, NSError *error);

- (id)init {
    _numberOfSections = 0;
    _newsItemsFound = NO;
    [self loadLocalNewsFile];
    return self;
    
}

/* Checks user defaults and compared last update time to see if a new one is needed */

- (BOOL)updateRequired {
    
    
    NSDate *lastUpdated = [self getLastUpdatedDate];
    // NSLog(@"Defaults: Last Updated = %@", lastUpdated);
    
    if (lastUpdated == nil) {
        // NSLog(@"No previous update has been found time");
        return YES;
    }
    
    NSTimeInterval lastUpdatedTimeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdated];
    // NSLog(@"last udpated raw = %f", lastUpdatedTimeInterval);
    NSInteger ti = (NSInteger)lastUpdatedTimeInterval;
    NSInteger minutes = (ti / 60);// % 60;
    
    // NSLog(@"Minutes since last Update = %d", minutes);
    
    
    if (minutes > kNewsUpdateInterval) {
        return YES;
    } else {
        return NO;
    }
}


- (void)getLatestNews:(NSString *)url withCallback:(NewsCompletionBlock)callback
{
    getServerResponseForUrlCallback = callback;
    // Start doing some time consuming tasks like sending a request to the backend services
 
    NSURL *urla = [NSURL URLWithString:kNewsFeedURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urla];
    
    // REQUESTING WEB SERVICE TO GET NEWS FROM FEED USING AF NETWORKING
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *jsonDict = [JSON objectForKey:@"entries"];
        
        [self saveJsonWithData:jsonDict];
        [self loadLocalNewsFile];
        [self onBackendResponse:nil withSuccess:YES error:nil];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // NSLog(@"Error %@ -", [error description]);
        [self onBackendResponse:JSON withSuccess:NO error:error];
        
    }];
    [operation start];
    // To see your callback in action uncomment the line below
}


- (NSDate *)getLastUpdatedDate {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdated = [defaults objectForKey:kNewsLastUpdatedDate];
    return lastUpdated;
}
// --------------
- (void)onBackendResponse:(NSDictionary *)response withSuccess:(BOOL)success error:(NSError *)error
{
    getServerResponseForUrlCallback(success, response, error);
}



- (void)loadLocalNewsFile {
    
    // NSLog(@"Loading local news file");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"news.json"];
    
    // Check if the file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // NSLog(@"No news exists");
        _newsArticles = nil;
        _newsItemsFound = NO;
        return;
    }
    
    NSDictionary *jsonDict = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *results = [NSMutableArray array];
    
    for (id postsDictionary in jsonDict) {
        NewsEntry *news = [[NewsEntry alloc] initWithDictionary:postsDictionary];
        [results addObject:news];
    }
    
    if ([results count] > 0) {
        _newsItemsFound = YES;
        _numberOfSections = 3;
    }
    
    _newsArticles = results;
}


- (void)saveJsonWithData:(NSDictionary *)json {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"news.json"];
    
    // NSLog(@"Path %@", filePath);
    
    //    NSError *error;
    [json writeToFile:filePath atomically:YES];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSDate date] forKey:kNewsLastUpdatedDate];
    [defaults synchronize];
    
    //    [json writeToFile:jsonPath atomically:YES encoding:NSASCIIStringEncoding error:&error];
    //
    //    if (error) {
    //        NSLog(@"Fail %@", [error description]);
    //    }
}


@end
