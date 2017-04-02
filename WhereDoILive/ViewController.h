//
//  ViewController.h
//  WhereDoILive
//
//  Created by Dan Patey on 3/21/17.
//  Copyright © 2017 Dan Patey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
