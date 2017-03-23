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
    // Pull in the latest Lat and Long
    float latitude = manager.location.coordinate.latitude;
    float longitude = manager.location.coordinate.longitude;
    NSLog(@"Current Latitude is: %f", latitude);
    NSLog(@"Current Longitude is: %f", longitude);
    
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
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    
    // If it's between 11pm and 5am set lat and long as "home"
    if ( [now timeIntervalSinceDate:earliestTime] > 0 && [now timeIntervalSinceDate:latestTime] < 0) {
        printf("This phone lives at:\n latitude: %f\n longitude: %f",latitude, longitude);
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot find location");
}

@end
