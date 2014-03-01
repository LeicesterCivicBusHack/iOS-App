//
//  NewsEntry.h
//
//  Created by Aaron Wardle on 22/04/2013.
//  Copyright (c) 2013 spcs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsEntry : NSObject


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *newsDate;
@property (nonatomic, copy) NSString *newsID;
@property (nonatomic, copy) NSString *newsImage;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *link;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
