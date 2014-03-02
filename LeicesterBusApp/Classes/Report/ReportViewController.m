//
//  ReportViewController.m
//  LeicesterBusApp
//
//  Created by Aaron Wardle on 01/03/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "ReportViewController.h"
#import "AFNetworking.h"
#import "BusApiClient.h"

#import "SelectCompanyTableViewController.h"

#define kDatePickerFieldIndex   3
#define kDatePickerHeight       162

@interface ReportViewController ()

@end

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"Report Bus";
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.topItem.title = @"";

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    
    _datePicker.maximumDate = [NSDate date];
    self.datePicker.alpha = 0.0f;
    self.datePicker.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat height = 44;
    
    if (indexPath.section == 0) {
        // Check for Expected Time Cell
        if (indexPath.row == kDatePickerFieldIndex) {
            height = self.datePickerIsShowing ? kDatePickerHeight : 0.0f;
        } else if (indexPath.row == kDatePickerFieldIndex + 1) {
            height = 82;
        }
    }else {
        height =  44;
    }
    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    
    if (indexPath.row == kDatePickerFieldIndex - 1) {
        
        if (self.datePickerIsShowing){
            
            [self hideDatePickerCell];
            return;
        }else {
            
            [self showDatePickerCell];
            return;
        }
        
    }
    
    
}


- (void)showDatePickerCell {
    
    self.datePickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView endUpdates];
    
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.alpha = 1.0f;
    }];
}

- (void)hideDatePickerCell {
    
    self.datePickerIsShowing = NO;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.datePicker.hidden = YES;
                     }];
}


#pragma mark - Date Picker
-(IBAction)pickerDateChanged:(UIDatePicker *)sender {
   
    _labelSelectedTime.text = [_dateFormatter stringFromDate:sender.date];
    _selectedDate = sender.date;
}

#pragma mark - 
#pragma mark - Report Button

- (void)sendReport {
    
    if ([[BusApiClient sharedInstance] isNetworkAvailable]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"nearest",@"command",
                                       @"", @"long",
                                       @"", @"lat", nil];
        
        NSLog(@"Params %@", params);
        
        [[BusApiClient sharedInstance] commandWithParams:params onCompletion:^(NSDictionary *json) {
            NSLog(@"Json Response %@", json);
        }];
    }
    
    
      
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"startButton"]) {
        NSLog(@"Start Tapped");
    }
    
    
    if ([[segue identifier] isEqualToString:@"selectCompany"]) {
        SelectCompanyTableViewController *vc = (SelectCompanyTableViewController*)segue.destinationViewController;
        vc.delegate = self;
        vc.selectedCompanyName = _lblBusCompany.text;
    }
    
}


#pragma mark -
#pragma mark - Select Company Delegate
-(void)getSiteSelectedCompanyName:(NSString *)companyName {

    _lblBusCompany.text = companyName;
}

@end
