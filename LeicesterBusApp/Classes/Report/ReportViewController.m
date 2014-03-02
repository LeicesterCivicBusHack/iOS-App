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
#import "MenuViewController.h"
#import "MMDrawerBarButtonItem.h"

#import "SelectCompanyTableViewController.h"
#import "ReportStartViewController.h"
#import "NearestStopsViewController.h"


#define kDatePickerFieldIndex   2
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
    
    locationManager = [[CLLocationManager alloc] init];
    
    [self getCurrentLocation];
    
    if (!_isAChildView) {
        [self setupLeftMenuButton];
    } else {
        self.navigationController.navigationBar.topItem.title = @"";
    }
    
}


#pragma mark - Left Menu Set-up
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}


#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)getCurrentLocation {

    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _latitude = currentLocation.coordinate.latitude;
        _longitude = currentLocation.coordinate.longitude;
    }
    
    [locationManager stopUpdatingLocation];
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
        } else if (indexPath.row == kDatePickerFieldIndex + 2) {
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
    
    
    if (indexPath.row == kDatePickerFieldIndex + 1) {
        NearestStopsViewController *vc = [[NearestStopsViewController alloc] initWithNibName:@"NearestStopsViewController" bundle:nil];
        vc.isAChildView = YES;
        vc.isAccessedViaReportView = YES;
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
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



- (IBAction)btnStart:(id)sender {
    
    if ((_longitude == 0) || (_latitude == 0)) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Error" message:@"Unable to determine location please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        
    } else if (_busStopLocation == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Report Error" message:@"Please select a bus stop to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
    
        [self performSegueWithIdentifier:@"startTapped" sender:nil];
        
    }
        
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"startTapped"]) {

        ReportStartViewController *vc = (ReportStartViewController*)segue.destinationViewController;
        
        vc.routeNumber = _txtBusNumber.text;
        vc.busCompany = _lblBusCompany.text;
        vc.longitude = _longitude;
        vc.latitude = _latitude;
        vc.expectedTime = _labelSelectedTime.text;
        vc.busStopLocation = _busStopLocation;
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


- (void)getSelectedBusLocation:(BusStopLocation *)busStopLocation {
    
    _busStopLocation = busStopLocation;
    _lblBusStop.text = busStopLocation.commonName;
    
}

@end
