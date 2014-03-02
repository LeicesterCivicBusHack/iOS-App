//
//  NSDictionary+Utility.m
//
//  Created by Aaron Wardle on 18/12/2012.
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
