//
//  NewsViewController.h
//
//  Created by Aaron Wardle on 13/02/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *news;
@property (nonatomic) NSInteger numberOfSections;

@end
