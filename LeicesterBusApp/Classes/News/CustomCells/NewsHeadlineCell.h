//
//  NewsHeadlineCell.h
//  GMB
//
//  Created by Aaron Wardle on 01/05/2013.
//  Copyright (c) 2013 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsHeadlineCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblSummary;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIImageView *newsImage;

@property (nonatomic, strong) IBOutlet UIView *titleView;


@end
