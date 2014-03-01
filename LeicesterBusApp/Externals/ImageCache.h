//
//  ImageCache.h
//
//  Created by Aaron Wardle on 19/10/2011.
//  Copyright (c) 2011 Smart PC Solutions Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject {}

// Class Methods
- (void) cacheImage: (NSString *) ImageURLString folderName: (NSString *) folder;
- (UIImage *) getCachedImage: (NSString *) ImageURLString folderName: (NSString *) folder;

// Used to clean the cache 
- (void) cleanCache: (NSString *) ImageFileName folderName: (NSString *) folder;


@end
