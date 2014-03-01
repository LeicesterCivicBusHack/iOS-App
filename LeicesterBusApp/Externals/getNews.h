//
//  getNews.h
//
//  Created by Aaron Wardle on 06/01/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getNews : NSObject

@property (nonatomic, strong) NSMutableArray *newsArticles;
@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) BOOL newsItemsFound;

typedef void (^NewsCompletionBlock)(BOOL success, NSDictionary *response, NSError *error);


- (void)getLatestNews:(NSString *)url withCallback:(NewsCompletionBlock)callback;
- (BOOL)updateRequired;

//- (void)getNews;

@end
