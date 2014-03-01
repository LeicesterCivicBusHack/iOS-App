//
//  ImageCache.m
//
//  Created by Aaron Wardle on 19/10/2011.
//  Copyright (c) 2011 Smart PC Solutions Ltd. All rights reserved.
//

#import "ImageCache.h"
#import "AppDelegate.h"
#define TMP NSTemporaryDirectory()



@implementation ImageCache

// i.e. http://www.domainname.com/image.jpg  folder = news
- (void) cacheImage:(NSString *)ImageURLString folderName: (NSString *) folder 
{
  
    NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
    
    // Get the file name
    NSArray  *parts = [ImageURLString componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];             // Gets the last part of the URL i.e. image.jpg


    // Set-up the paths 
    // We will store our images and files in NSCachesDirectory
     
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];
    
    // Append the file name to the generated path
    path = [path stringByAppendingPathComponent: filename];
    
    if ([folder isEqual: @"images"]) {
       // NSLog(@"Changing the Path as its an APP");
        path = [TMP stringByAppendingPathComponent: filename];
    } 
    
    // Check if the file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath: path])
    {
        // The file does not exist, so we should download it
        //        NSLog(@"ADDING to cache - %@", filename);
        
        // Fetch Image
        NSData *data = [[NSData alloc] initWithContentsOfURL:ImageURL];
        UIImage *image = [[UIImage alloc] initWithData: data];
        
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            BOOL success = [UIImagePNGRepresentation(image) writeToFile: path atomically: YES];
            if (!success) {
                // Should capture errors here perhaps?
                // NSLog(@"error writing file");
            }
        }
        else if
            (
                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
            )
        {
            BOOL success = [UIImageJPEGRepresentation(image, 100) writeToFile: path atomically: YES];
            if (!success) {
                // Should capture errors here perhaps?
               // NSLog(@"error writing file");
            }
        }
        
        image = nil;
      //  [data release];
      //  [image release];
        
    }
}


- (UIImage *) getCachedImage: (NSString *) ImageURLString folderName: (NSString *) folder
{
    
    // Get the file name
    NSArray  *parts = [ImageURLString componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1]; // Pulls the image name i.e. image.jpg
       
    /* New Stuff for cache folder */
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];

    path = [path stringByAppendingPathComponent: filename];
    
    // Store the Apps Images in the TMP Folder which iOS Manages. 
    if ([folder isEqual: @"images"] ) {
       // NSLog(@"Changing the Path as its an APP");
        path = [TMP stringByAppendingPathComponent: filename];
    } 
    
    
    UIImage *image;

    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: path])
    {
        //NSLog(@"File exist in cache we reuse");
        // File already exists in the cache so we use that
        image = [UIImage imageWithContentsOfFile: path]; // this is the cached image
    }
    else
    {
        // NSLog(@"NO CACHE - Image %@", filename);
        // Download a new image and store it in the cache
        [self cacheImage: ImageURLString folderName:folder];
        image = [UIImage imageWithContentsOfFile: path];
    }
    
    return image;
}



// Clean the cache

- (void) cleanCache: (NSString *) ImageFileName folderName: (NSString *) folder{
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:folder];
    
    
//    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:TMP error:nil];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (files == nil) {
        // error...
       // NSLog(@"no files found");
    }
    
    // Clean Up 
    /* This could be made better */
    //
    // Put the Dictionary into an Array
    
     //AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // NSArray *newsArray = [myDelegate.newsData allValues];
    
     // Convert the Array into a string
    // NSString *newsString = [newsArray description];
    
    NSString *newsString;
     // Perform Range Search.
     NSRange range;
    
    for (NSString *file in files) {
        
        //NSString *uniquePath = [TMP stringByAppendingPathComponent: file];
        NSString *uniquePath = [path stringByAppendingPathComponent: file];
        if([file rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            ///NSLog(@"%@", file);   
            
            range = [newsString rangeOfString : file];
            
            if (range.location != NSNotFound) {
               // NSLog(@"The file exists in the plist %@", file);
            } else {
                //NSLog(@"FILE NOT IN PLIST = %@", file);
                if ([[NSFileManager defaultManager] removeItemAtPath: uniquePath error: NULL]  == YES) {
                 //   NSLog (@"Remove successful");
                } //                else
                 //   NSLog (@"Remove failed");
            }
        }
     
        if([file rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
           // NSLog(@"%@", file);   
            
            range = [newsString rangeOfString : file];
            
            if (range.location != NSNotFound) {
               // NSLog(@"The file exists in the plist %@", file);
            } else {
              //  NSLog(@"FILE NOT IN PLIST = %@", file);
                if ([[NSFileManager defaultManager] removeItemAtPath: uniquePath error: NULL]  == YES) {
                    
                }
                  //  NSLog (@"Remove successful");
                //else
                //    NSLog (@"Remove failed");
            }
        }
      
    }
    
}

@end
