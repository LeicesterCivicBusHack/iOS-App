//
//  NewsDetailViewController.h
//
//  Created by Aaron Wardle on 13/02/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEntry.h"


@interface NewsDetailViewController : UIViewController <UIWebViewDelegate>


@property (nonatomic, strong) IBOutlet UIWebView *contentWebView;

@property (nonatomic, strong) NewsEntry *newsEntry;


@end
