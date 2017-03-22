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
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
//            NSLog(@"********* Updating Location *********");
//            NSLog(@"latitude: %@", txtLatitude);
//            NSLog(@"longitude: %@", txtLongitude);
//            NSLog(@"");
            placemark = [placemarks lastObject];
            txtLatitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            txtLongitude.text = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
            printf("locationManager Fired");
        }
        else {
            NSLog(@"Cannot find location");
        }
    }];
}

-(void) applicationDidEnterBackground:(UIApplication *) application
{
    [locationManager startUpdatingLocation];
    printf("Entered background");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Cannot find location");
}

@end
