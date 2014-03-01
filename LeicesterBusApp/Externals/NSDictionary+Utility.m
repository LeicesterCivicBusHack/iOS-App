//
//  NSDictionary+Utility.m
//  Boxego
//
//  Created by Aaron Wardle on 18/12/2012.
//  Copyright (c) 2012 Boxego. All rights reserved.
//

#import "NSDictionary+Utility.h"

@implementation NSDictionary (Utility)

- (id)objectForKeyNotNull:(NSString *)key {
    id val = [self objectForKey:key];
    if ([val isEqual:[NSNull null]]) {
        return nil;
    }
    
    return val;
}

@end
