//
//  DirectionsViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/25/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "DirectionsViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DirectionsViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation DirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // request directions from Apple
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];

    // set source to current location for now
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    
    // Make the destination
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(38.8977, -77.0365);
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    // Set the source and destination on the request
    [directionsRequest setSource:source];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
