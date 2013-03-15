//
//  DMRViewController.m
//  Locator
//
//  Created by Dan Reife on 2/15/13.
//  Copyright (c) 2013 Dan Reife. All rights reserved.
//

#import "DMRViewController.h"

@interface DMRViewController ()

@end

@implementation DMRViewController

    NSUInteger numberOfPins = 1;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Get the locationManager from DMRAppDelegate, initialize if necessary
    DMRAppDelegate *AppDelegate = (DMRAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (AppDelegate.locationManager == nil) {
        AppDelegate.locationManager = [[CLLocationManager alloc] init];
    }
    
    // Assign the locationManager's delegate and other settings
    AppDelegate.locationManager.delegate = self;
    AppDelegate.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    AppDelegate.locationManager.distanceFilter = kCLLocationAccuracyKilometer;
    
    // Update location if possible, otherwise request user to allow location updates
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        [self centerViewAtLocation:AppDelegate.locationManager.location:NO];
        [AppDelegate.locationManager startUpdatingLocation];
    }
    else {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                 message:@"To re-enable, please go to: \nSettings > Privacy > Location."
                delegate:nil
       cancelButtonTitle:@"Okay"
       otherButtonTitles:nil];
        [alert show];
    }
}

- (void) centerViewAtLocation:(CLLocation *)location
                             :(BOOL)animated {
    MKCoordinateRegion region =
        MKCoordinateRegionMakeWithDistance(location.coordinate, 7500, 7500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:adjustedRegion animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // When location is updated, add a pin and move the view.
    CLLocation *location = [locations lastObject];
    [self addPinToMapAtLocation:location];
    [self centerViewAtLocation:location:YES];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
}

- (void)addPinToMapAtLocation:(CLLocation *)location
{
    NSString *number;
    number = [NSString stringWithFormat:@"%d",numberOfPins++];
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = location.coordinate;
    pin.title = @"Pin";
    pin.subtitle = number;
    [self.mapView addAnnotation:pin];
}



@end
