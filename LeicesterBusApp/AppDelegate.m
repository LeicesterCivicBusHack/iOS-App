//
//  AppDelegate.m
//
//  Created by Aaron Wardle on 13/02/2014.
//  Copyright (c) 2014 spcs. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
//#import "HomeScreenViewController.h"
#import "NewsViewController.h"
#import "HomeScreenViewController.h"

// Drawer Stuff
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMNavigationController.h"
#import "MMExampleDrawerVisualStateManager.h"

// Beacon Stuff
#import "ESTBeaconManager.h"

@interface AppDelegate () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) MMDrawerController *drawerController;

// Beacon Stuff
@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeacon *selectedBeacon;

@end


@implementation AppDelegate {
    BOOL _isInsideRegion; // flag to prevent duplicate sending of notification
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Starts the iBeacon Monitoring
    // [self startBeaconMonitoring];
    
//    NewsViewController *vc = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
//
    HomeScreenViewController *vc = [[HomeScreenViewController alloc] initWithNibName:@"HomeScreenViewController" bundle:nil];
    
    
    MMNavigationController *nc = [[MMNavigationController alloc] initWithRootViewController:vc];
    nc.navigationBar.translucent = NO;
    
    UIViewController *leftSideDrawerController = [[MenuViewController alloc] init];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:nc leftDrawerViewController:leftSideDrawerController];
    
    // Generic stuff which is shared
    
    [self.drawerController setShowsShadow:YES];
    
    
    
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    
    
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window setRootViewController:self.drawerController];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - 
#pragma mark - iBeacon Stuff
- (void)startBeaconMonitoring {
    
    // Set-up the Beacon
    // craete manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                                  identifier:@"EstimoteSampleRegion"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    
    [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:region];
    [self.beaconManager startMonitoringForRegion:region];
    [self.beaconManager requestStateForRegion:region];
    
}

- (void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        // don't send any notifications
        NSLog(@"App is active don't bother ");
        return;
    }
    
    
    if (state == CLRegionStateOutside) {
        if (_isInsideRegion) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"You are outside";
            notification.soundName = UILocalNotificationDefaultSoundName;
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            
            
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Come in" message:@"Hey why dont you come into the store" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            //        [alert show];
            NSLog(@"Outside");
            
            _isInsideRegion = NO;
        }
        
    } else if (state == CLRegionStateInside) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wanna buy a show" message:@"Want to check if its in stock" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        //        [alert show];
        
        if (!_isInsideRegion) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertBody = @"Would you like some help with trainer sizes?";
            notification.soundName = UILocalNotificationDefaultSoundName;
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
            NSLog(@"inside");
            
            _isInsideRegion = YES;
        }
    }
    
    
}


-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    if([beacons count] > 0)
    {
        
        if(!self.selectedBeacon)
        {
            // initialy pick closest beacon
            self.selectedBeacon = [beacons objectAtIndex:0];
        }
        else
        {
            for (ESTBeacon* cBeacon in beacons)
            {
                // update beacon it same as selected initially
                if([self.selectedBeacon.major unsignedShortValue] == [cBeacon.major unsignedShortValue] &&
                   [self.selectedBeacon.minor unsignedShortValue] == [cBeacon.minor unsignedShortValue])
                {
                    self.selectedBeacon = cBeacon;
                }
            }
        }
        
        
        
        // beacon array is sorted based on distance
        // closest beacon is the first one
        
        NSString* labelText = [NSString stringWithFormat:
                               @"Major: %i, Minor: %i\nRegion: ",
                               [self.selectedBeacon.major unsignedShortValue],
                               [self.selectedBeacon.minor unsignedShortValue]];
        
        // calculate and set new y position
        switch (self.selectedBeacon.proximity)
        {
            case CLProximityUnknown:
                labelText = [labelText stringByAppendingString: @"Unknown"];
                break;
            case CLProximityImmediate:
                labelText = [labelText stringByAppendingString: @"Immediate"];
                break;
            case CLProximityNear:
                labelText = [labelText stringByAppendingString: @"Near"];
                break;
            case CLProximityFar:
                labelText = [labelText stringByAppendingString: @"Far"];
                break;
                
            default:
                break;
        }
        NSLog(@"label Text %@", labelText);
        //  self.distanceLabel.text = labelText;
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
//    [[UIApplication sharedApplication] cancelLocalNotification:notification];
//    
//    SPCSLoginViewController *vc = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"shoeSize"];
//    
//    [self.window setRootViewController:vc];
    
    
}



#pragma mark -
#pragma mark - Core Data Stuff

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LeicesterBusApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LeicesterBusApp.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
