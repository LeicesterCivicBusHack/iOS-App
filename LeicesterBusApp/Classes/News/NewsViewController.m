//
//  NewsViewController.m
//
//  Created by Aaron Wardle on 13/02/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "NewsViewController.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "ImageCache.h"
#import "getNews.h"
#import "NewsEntry.h"

#import <QuartzCore/QuartzCore.h>
#import "MMDrawerBarButtonItem.h"
#import "MenuViewController.h"

// Custom Cells
#import "NewsHeadlineCell.h"
#import "NewsCustomCell.h"
#import "CustomCellNews.h"

// News Detail View
#import "NewsDetailViewController.h"



@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"News";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:223.0/255.0 green:222.0/255.0 blue:224.0/255.0 alpha:1.0]];
    
    _numberOfSections = 0;
    
    [self setupLeftMenuButton];
    
    getNews *theNews = [[getNews alloc] init];
    _news = theNews.newsArticles;
    _numberOfSections = theNews.numberOfSections;
    
    [self.tableView reloadData];
    
    
    if ([theNews updateRequired]) {
        [self fetchTheLatestNewsArticles];
    }
}



- (void)fetchTheLatestNewsArticles {
    
    getNews *theNews = [[getNews alloc] init];
    
    // Running in a block so that we get a callback when download saved and parsed.
    [theNews getLatestNews:@"" withCallback:^(BOOL success, NSDictionary *response, NSError *error) {
        
        if (success) {
            _news = theNews.newsArticles;
            _numberOfSections = theNews.numberOfSections;
            [self.tableView reloadData];

        } else {
            NSLog(@"There was an error %@", [error description]);
        }
    }];
    
}


#pragma mark - Drawer Button Handlers
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}


-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark -
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _numberOfSections;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (indexPath.section == 0) {
        return 225;
    } else {
        return 85; // 110;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section ==1) {
        return [_news count] / 2 ;   // Change this to the array count
    } else {
        return [_news count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    view.backgroundColor = [UIColor colorWithRed:232.0/255.0
                                           green:231.0/255.0
                                            blue:232.0/255.0
                                           alpha:1.0];
    
    UIView *blackAreaView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 300, 26)];
    blackAreaView.backgroundColor = [UIColor blackColor];
    
    [view addSubview:blackAreaView];
    
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @""; // Featured Article Area
            break;
        case 1:
            sectionName = @"Latest News";
            break;
            // ...
        default:
            sectionName = @"Featured News";
            break;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 5, 300, 16);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    //    label.shadowColor = [UIColor grayColor];
    //    label.shadowOffset = CGSizeMake(-1.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionName;
    
    [blackAreaView addSubview:label];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    
    if (section ==0) {
        return  0;
    } else {
        return 26;
    }
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionName;
//    switch (section)
//    {
//        case 0:
//sectionName = @"hi";
//            break;
//        case 1:
//            sectionName = @"Latest";
//            break;
//            // ...
//        default:
//            sectionName = @"";
//            break;
//    }
//    return sectionName;
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            // News Headline Cell
            /* Used only for the first cell */
            static NSString *CellIdentifier = @"NewsHeadlineCell";
            NewsHeadlineCell *cell = (NewsHeadlineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsHeadlineCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            NewsEntry *news = [_news objectAtIndex:indexPath.row];
            
            
            
            ImageCache *imgCache = [ImageCache alloc];
            
            cell.newsImage.image = nil;
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                
                UIImage *image = [imgCache getCachedImage:news.newsImage folderName:@"images"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [cell.newsImage setImage:image];
                    [cell setNeedsLayout];
                });
                
            });
            
            //  cell.titleView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            [cell.lblTitle setFont:[UIFont fontWithName:@"PTSans-Bold" size:18]];
            cell.lblTitle.text = [news.title uppercaseString];
            cell.lblTitle.numberOfLines = 0;
            [cell.lblTitle sizeToFit];
            return cell;
            
        }
    }
    
    
    
    // All other Cells
    //
    static NSString *CellIdentifier = @"NewsCell";
    
    CustomCellNews *cell = (CustomCellNews *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellNews" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    //        NSIndexPath *path;
    
    NewsEntry *news;
    // if (indexPath.row == 0) {
    news = [_news objectAtIndex:indexPath.row];
    
    
    // } else {
    //   news = [_news objectAtIndex:indexPath.row];
    // }
    
    //  NewsEntry *news = [_news objectAtIndex:path.row];
    ImageCache *imgCache = [ImageCache alloc];
    
    cell.imageView.image = nil;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        UIImage *image = [imgCache getCachedImage:news.newsImage folderName:@"images"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [cell.image setImage:image];
            cell.image.layer.cornerRadius = 6.0f;
            //   cell.image.layer.shadowOffset = CGSizeMake(0,5);
            cell.image.clipsToBounds = YES;
            [cell setNeedsLayout];
        });
    });
    
    [cell.title setFont:[UIFont fontWithName:@"PT Sans" size:14]];
    
    cell.lblDate.text = news.newsDate;
    cell.title.text =  news.title;
    cell.summary.text = news.description;
    
    // CustomColoredAccessory *accessory = [CustomColoredAccessory accessoryWithColor:[UIColor blackColor]];
    //accessory.highlightedColor = [UIColor colorWithRed:(190.0f/255.0f) green:(31.0f/255.0f) blue:(32.0f/255.0f) alpha:1.0f];
    //cell.accessoryView =accessory;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIColor *tableViewBackgroundColor;
    tableViewBackgroundColor = [UIColor colorWithRed:232.0/255.0
                                               green:231.0/255.0
                                                blue:232.0/255.0
                                               alpha:1.0];
    
    
    cell.backgroundColor = tableViewBackgroundColor;
    
    //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0,80, 300, 1)];
    seperatorView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:seperatorView];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsEntry *entry = [_news objectAtIndex:indexPath.row];
    NewsDetailViewController *vc = [[NewsDetailViewController alloc] initWithNibName:@"NewsDetailViewController" bundle:nil];
    
    vc.newsEntry = entry;
    vc.title = @"GMB News";
    
    [[self navigationController] pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
