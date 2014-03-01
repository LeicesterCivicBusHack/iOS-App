//
//  RoutesWebViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoutesWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *selectedCompany;
@property (nonatomic, strong) NSString *selectedURL;


@end
