//
//  SelectCompanyTableViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCompanyDelegate <NSObject>

-(void)getSiteSelectedCompanyName:(NSString *)companyName;

@end


@interface SelectCompanyTableViewController : UITableViewController

@property(nonatomic, weak)id<SelectCompanyDelegate> delegate;
@property (nonatomic, strong) NSString *selectedCompanyName;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndex;

@property (nonatomic, strong) NSArray *arrayCompanies;


@end
