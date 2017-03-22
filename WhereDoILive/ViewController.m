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
    CLPlacemark *placemark;
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
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
        if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive) {
//            NSLog(@"********* Updating Location *********");
//            NSLog(@"latitude: %@", txtLatitude);
//            NSLog(@"longitude: %@", txtLongitude);
//            NSLog(@"");
            txtLatitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            txtLongitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            printf("AppIsActive\n");
        }
        else {
            NSLog(@"App is backgrounded. New location is %@", locations);
        }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot find location");
}

@end
