//
//  NewsDetailViewController.m
//
//  Created by Aaron Wardle on 13/02/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsEntry.h"
#import "ImageCache.h"


@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                action:@selector(shareButtonClicked)];
    

    self.navigationItem.rightBarButtonItem = shareButton;
    
    _contentWebView.backgroundColor = [UIColor clearColor];
	_contentWebView.scalesPageToFit = YES;
    
    
    NSString *strTitleCaps = [_newsEntry.title uppercaseString];
    
    NSString *htmlFile;
    
    htmlFile = [[NSBundle mainBundle] pathForResource:@"iPhoneNewsArticle" ofType:@"html"];
    
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%%image%%" withString:_newsEntry.newsImage];
    
    // HeadLine
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%%headline%%" withString:strTitleCaps];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%%published%%" withString:_newsEntry.newsDate];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%%content%%" withString:_newsEntry.content];
    
	[_contentWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.apple.com"]];

}


- (void)shareButtonClicked
{
    
    
    //-- set up the data objects
    NSString *textObject = _newsEntry.title;
    NSString *urlString = [NSString stringWithFormat:@"http://www.mistabus.co.uk/%@", _newsEntry.link];
    
    NSURL *url = [NSURL URLWithString:urlString];

    NSArray *activityItems = [NSArray arrayWithObjects:textObject, url,  nil];
    
    //-- initialising the activity view controller
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems:activityItems
                                     applicationActivities:nil];
    
    
    avc.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard ];
    
    
    //-- define the activity view completion handler
    avc.completionHandler = ^(NSString *activityType, BOOL completed){
        if (completed) {
            // NSLog(@"Selected activity was performed.");
        } else {
            if (activityType == NULL) {
                //   NSLog(@"User dismissed the view controller without making a selection.");
            } else {
                //  NSLog(@"Activity was not performed.");
            }
        }
    };
    
    //-- show the activity view controller
    [self presentViewController:avc animated:YES completion:nil];
    
}



#pragma mark -
#pragma mark Web View Delegate Methods

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    // Used to resize the content aera and adjust scrollview height
//    
//    CGRect frame = _contentWebView.frame;
//    // frame.size.height = 1;
//    _contentWebView.frame = frame;
//    CGSize fittingSize = [_contentWebView sizeThatFits:CGSizeZero];
//    frame.size = fittingSize;
//    _contentWebView.frame = frame;
//    
//    [_contentScrollView setContentSize:CGSizeMake(320, fittingSize.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
