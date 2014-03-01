//
//  ReportViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UITableViewController

@property (assign) BOOL datePickerIsShowing;
@property (nonatomic, weak) IBOutlet UILabel *labelSelectedTime;

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *selectedDate;


-(IBAction)pickerDateChanged:(UIDatePicker *)sender;


@end
