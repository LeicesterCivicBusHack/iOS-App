//
//  CustomCellNews.h
//  GMB
//
//  Created by Aaron Wardle on 22/04/2013.
//  Copyright (c) 2013 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellNews : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *summary;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;


@end
