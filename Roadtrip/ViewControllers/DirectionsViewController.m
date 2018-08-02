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

@interface DirectionsViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSArray *pointsAlongRoute;
@property (assign, nonatomic) double currentLatitude;
@property (assign, nonatomic) double currentLongitude;
@property (assign, nonatomic)int locationFetchCounter;

@end

@implementation DirectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.geocoder = [[CLGeocoder alloc] init];

    self.mapView.delegate = self;
    
    [self doFetchLocation];
}

-(void)doFetchLocation {
    // reset location counter
    self.locationFetchCounter = 0;
    
    // fetching current location start from here
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // this delegate method is constantly invoked every some miliseconds.
    // we only need to receive the first response, so we skip the others.
    if (self.locationFetchCounter > 0) return;
    self.locationFetchCounter++;
    
    CLLocation *currentLocation = [locations lastObject];
    
    self.currentLatitude = currentLocation.coordinate.latitude;
    self.currentLongitude = currentLocation.coordinate.longitude;
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark *placemarkSource = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.currentLatitude, self.currentLongitude) addressDictionary:nil];
    MKPlacemark *placemarkDestination = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(34.0522, -118.2437) addressDictionary:nil];
    
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:placemarkSource];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemarkDestination];
    
    request.destination = destination;
    request.source = source;
    request.requestsAlternateRoutes = YES;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    __block NSArray *pointsAlongRoute;
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"%@", error);
         } else {
             NSLog(@"hello");
             [self showRoute:response];
             self.pointsAlongRoute = [self getPointsAlongRoute:response];
             [self displayPointsAlongRoute];
         }
     }];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to fetch current location : %@", error);
}

-(NSArray *)getPointsAlongRoute:(MKDirectionsResponse *)response
{
    MKRoute *route = response.routes[0];
    NSUInteger pointCount = route.polyline.pointCount;
    NSLog(@"Number of points along route: %lu", pointCount);
    
    //NSMutableArray *stops = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D *myCoordinates = malloc(sizeof(CLLocationCoordinate2D) * 3);
    int numStops = 3;
    for (int i = 0; i < numStops; i++)
    {
        CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D));
        // get coordinates of stops
        [route.polyline getCoordinates:coordinates range:NSMakeRange(pointCount / (numStops * 2) * (i + 1), 1)];
        // add to array of stops
        //[myCoordinates addObject:(__bridge id)&coordinates[0]];
        myCoordinates[i] = coordinates[0];
    }
    
    for (int i = 0; i < numStops; i++)
    {
        NSLog(@"Stops: %f, %f", myCoordinates[i].latitude, myCoordinates[i].longitude);
    }

    NSMutableArray *arrayCoordinates = [[NSMutableArray alloc] init];
    for (int i = 0; i < numStops; i ++)
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(myCoordinates[i].latitude, myCoordinates[i].longitude);
        [arrayCoordinates addObject:[NSValue valueWithBytes:&coord objCType:@encode(CLLocationCoordinate2D)]];
    }
    for (int i = 0; i < numStops; i++)
    {
        CLLocationCoordinate2D coordinate;
        [[arrayCoordinates objectAtIndex:0] getValue:&coordinate];
        NSLog(@"Coordinates: %f, %f", coordinate.latitude, coordinate.longitude);
    }
    
    return arrayCoordinates;
}

-(void)displayPointsAlongRoute {
    
    for (int i=0; i<3; i++) {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        CLLocationCoordinate2D coordinate;
        [[self.pointsAlongRoute objectAtIndex:i] getValue:&coordinate];
        annotation.coordinate= coordinate;
        [self.mapView addAnnotation: annotation];
    }
    
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    MKRoute *route = response.routes[0];
    
    NSArray *points = route.steps;
    
    NSLog(@"%f", route.expectedTravelTime);
    
    for(int i = 0; i < points.count; i++) {
        
        MKRouteStep *step = points[i];
        NSLog(@"Instruction: %@", step.instructions);
        
    }
    
    NSLog(@"Points: %@", points);
    
    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    
    for (MKRouteStep *step in route.steps)
    {
        NSLog(@"%@", step.instructions);
    }
    
    NSLog(@"%f", route.expectedTravelTime);
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
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
