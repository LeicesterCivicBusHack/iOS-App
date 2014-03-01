//
//  NewsEntry.m
//
//  Created by Aaron Wardle on 22/04/2013.
//  Copyright (c) 2013 spcs. All rights reserved.
//

#import "NewsEntry.h"
#import "NSDictionary+Utility.h"

@implementation NewsEntry



- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        //NSLog(@"Dict = %@", dictionary);
        _title = [dictionary objectForKeyNotNull:@"title"];
        
        NSString *summary = [dictionary objectForKeyNotNull:@"introtext"];
        summary = [summary stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        summary = [summary stringByReplacingOccurrencesOfString:@"</p>" withString:@""];

        
        
        _description = summary; //[dictionary objectForKey:@"introtext"];
        _newsID = [dictionary objectForKeyNotNull:@"guid"];
        _newsImage = [dictionary objectForKeyNotNull:@"image"];
        _content = [dictionary objectForKeyNotNull:@"content"];
        _newsDate = [dictionary objectForKeyNotNull:@"date"];
        _link = [dictionary objectForKeyNotNull:@"link"];
        //NSLog(@"Link %@", _link);
    }
    
    return self;
    
}
@end
