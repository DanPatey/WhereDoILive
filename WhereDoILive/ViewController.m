//
//  ViewController.m
//  WhereDoILive
//
//  Created by Dan Patey on 3/21/17.
//  Copyright © 2017 Dan Patey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CLGeocoder *geocoder;
}

@end

@implementation ViewController
@synthesize locationManager;
@synthesize txtLongitude, txtLatitude;

- (void)viewDidLoad {
    [super viewDidLoad];
    geocoder = [[CLGeocoder alloc] init];
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Pull in the latest Lat and Long and truncate to two decimal places for comparison
    double currentLatitude = trunc(manager.location.coordinate.latitude * 100) / 100;
    double currentLongitude = trunc(manager.location.coordinate.longitude * 100) / 100;
    NSLog(@"Current Latitude is: %f\n", currentLatitude);
    NSLog(@"Current Longitude is: %f\n", currentLongitude);
    
    // Create a comparison for 11pm
    NSDate *earliestTime = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *earliestTimeComponents =
    [gregorian components:(NSCalendarUnitWeekday | NSCalendarUnitWeekday) fromDate:earliestTime];
    [earliestTimeComponents setHour:23];
    [earliestTimeComponents setMinute:00];
    
    // Create a comparison for 5am
    NSDate *latestTime = [NSDate date];
    NSDateComponents *latestTimeComponents =
    [gregorian components:(NSCalendarUnitWeekday | NSCalendarUnitWeekday) fromDate:latestTime];
    [latestTimeComponents setHour:05];
    [latestTimeComponents setMinute:00];

    // Create a comparison for the current time
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
//    NSString *newDateString = [outputFormatter stringFromDate:now];
//    NSLog(@"newDateString %@", newDateString);
    
    // If it's between 11pm and 5am set lat and long as "home"
    if ([now timeIntervalSinceDate:earliestTime] > 0 || [now timeIntervalSinceDate:latestTime] < 0) {
        
        printf("It's between 11pm and 5am. Time for a ping. \n");
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
        NSMutableArray *timesArray = [NSMutableArray arrayWithContentsOfFile:path];
        
        [timesArray addObject:[NSNumber numberWithDouble:currentLongitude]];
        [timesArray addObject:[NSNumber numberWithDouble:currentLatitude]];
        [timesArray writeToFile:@"/Users/danpatey/workspace/WhereDoILive/WhereDoILive/test.plist" atomically:YES];
        
        NSLog(@"%@", timesArray);
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot find location");
}

@end
