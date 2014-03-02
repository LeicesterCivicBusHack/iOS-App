//
//  ReportViewController.h
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCompanyTableViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ReportViewController : UITableViewController <SelectCompanyDelegate, CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
}

@property (assign) BOOL datePickerIsShowing;
@property (nonatomic, weak) IBOutlet UILabel *labelSelectedTime;

@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *selectedDate;


@property (nonatomic, weak) IBOutlet UITextField *txtBusNumber;
@property (nonatomic, weak) IBOutlet UILabel *lblBusCompany;
@property (assign) CGFloat longitude;
@property (assign) CGFloat latitude;

@property (nonatomic) BOOL isAChildView;

-(IBAction)pickerDateChanged:(UIDatePicker *)sender;

-(IBAction)btnStart:(id)sender;


@end
