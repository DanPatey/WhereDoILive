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
    
    // If it's between 11pm and 5am grab lat and long
    if ([now timeIntervalSinceDate:earliestTime] > 0 || [now timeIntervalSinceDate:latestTime] < 0) {
        printf("It's between 11pm and 5am. Time for a ping. \n");
        
        NSString *longitudePlist = [[NSBundle mainBundle] pathForResource:@"longitude" ofType:@"plist"];
        NSMutableArray *longitudeArray = [NSMutableArray arrayWithContentsOfFile:longitudePlist];
        NSString *latitudePlist = [[NSBundle mainBundle] pathForResource:@"latitude" ofType:@"plist"];
        NSMutableArray *latitudeArray = [NSMutableArray arrayWithContentsOfFile:latitudePlist];
        
        [longitudeArray addObject:[NSNumber numberWithDouble:currentLongitude]];
        [latitudeArray addObject:[NSNumber numberWithDouble:currentLatitude]];
        
        [longitudeArray writeToFile:@"/Users/danpatey/workspace/WhereDoILive/WhereDoILive/longitude.plist" atomically:YES];
        [latitudeArray writeToFile:@"/Users/danpatey/workspace/WhereDoILive/WhereDoILive/latitude.plist" atomically:YES];
        
        // Find the most common occurances and set those to the phone's "home"
        NSCountedSet *longitudeBag = [[NSCountedSet alloc] initWithArray:longitudeArray];
        NSString *mostOccuringLongitude;
        NSUInteger highestLong = 0;
        for (NSString *s in longitudeBag) {
            if([longitudeBag countForObject:s] > highestLong) {
                highestLong = [longitudeBag countForObject:s];
                mostOccuringLongitude = s;
            }
        }
        
        NSCountedSet *latitudeBag = [[NSCountedSet alloc] initWithArray:latitudeArray];
        NSString *mostOccuringLatitude;
        NSUInteger highestLat = 0;
        for (NSString *s in latitudeBag) {
            if([latitudeBag countForObject:s] > highestLat) {
                highestLat = [latitudeBag countForObject:s];
                mostOccuringLatitude = s;
            }
        }
        NSLog(@"This phone lives at: %@, %@", mostOccuringLongitude, mostOccuringLatitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot find location");
}

@end
