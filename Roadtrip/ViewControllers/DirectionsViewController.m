//
//  DirectionsViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/25/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "DirectionsViewController.h"
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "GoogleMapsManager.h"
#import "Landmark.h"
#import <CoreLocation/CoreLocation.h>

// number of stops we want along the way
static int const numStops = 3;
// how many times more points we want to check compared to number of stops
// created to improve efficiency so we dont check every single point along the route
static int const multiplier = 20;

// completion block for after
typedef void (^completionGetPointsAlongWay)(void);

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
    
    // __block NSArray *pointsAlongRoute;
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"%@", error);
         } else {
             NSLog(@"hello");
             [self showRoute:response];
             self.pointsAlongRoute = [self getPointsAlongRoute:response
                                           withCompletionBlock:^() {
                                            
                                           }];
             [self displayPointsAlongRoute];
         }
     }];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"failed to fetch current location : %@", error);
}

-(NSMutableArray *)getLandmarksAlongRoute
{
    NSMutableArray *allLankmarks = [[NSMutableArray alloc] init];
    for (int i = 0; i < numStops; i++)
    {
        CLLocationCoordinate2D coordinate;
        [[self.pointsAlongRoute objectAtIndex:i] getValue:&coordinate];
        
    }
    return allLankmarks;
}

-(NSArray *)getLandmarks:(int)radius withLocation:(CLLocationCoordinate2D) coordinate{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GoogleMapsManager *myManagerGoogle = [GoogleMapsManager new];
    
    __block NSArray *landmarks;
    
    [myManagerGoogle getPlacesNearLatitude:coordinate.latitude nearLongitude:coordinate.longitude withRadius: radius withCompletion:^(NSArray *placesDictionaries, NSError *error)
     {
         if(placesDictionaries)
         {
             
             landmarks = [Landmark initWithArray:placesDictionaries];
             
             landmarks = [NSMutableArray arrayWithArray: [Landmark sortLandmarkByRating:landmarks]];
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
         else
         {
             NSLog(@"No places found");
         }
     }];
    
    return landmarks;
}

-(NSArray *)getPointsAlongRoute:(MKDirectionsResponse *)response
            withCompletionBlock: (completionGetPointsAlongWay)compBlock
{
    MKRoute *route = response.routes[0];
    // what the distance should be for radius
    int distance = route.distance / (numStops * 2);
    
    // number of points returned
    NSUInteger pointCount = route.polyline.pointCount;
    NSLog(@"Number of points along route: %lu", pointCount);
    
    // keep track of distance for each iteration
    int distanceKeepTrack = 0;
    
    // array of stops along the way
    CLLocationCoordinate2D *myCoordinates = malloc(sizeof(CLLocationCoordinate2D) * numStops);
    
    // index in the saved array of stops
    int index = 0;
    
    // save the previous checked point to get incremental distance
    CLLocation *previousLocation = [[CLLocation alloc] initWithLatitude:self.currentLatitude longitude:self.currentLongitude];

    
    for (int i = 0; i < numStops * multiplier; i++)
    {
        CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D));
        // get coordinates of stops
        [route.polyline getCoordinates:coordinates range:NSMakeRange(pointCount / (numStops * multiplier) * i, 1)];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinates[0].latitude longitude:coordinates[0].longitude];
        
        // get distance from current to previous point
        CLLocationDistance dist = [location distanceFromLocation:previousLocation];
        
        // add distance from current to previous point to the current tally of distance
        distanceKeepTrack += dist;
        
        // set the current point as previousLocation in preparation for next iteration
        previousLocation = location;
        
        // if this point exceeds the threshold, add it to the array of stops and reset everything
        if (distanceKeepTrack > distance)
        {
            distanceKeepTrack = 0;
            // add the current coordinate to the array of stops along the way
            myCoordinates[index] = coordinates[0];
            index ++;
            // set the distance to 1/numStops of the total distance
            // we only want 1/(2 * numStops) for between the first stop and current location because geometry
            distance = route.distance / numStops;
        }
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
        [[arrayCoordinates objectAtIndex:i] getValue:&coordinate];
        NSLog(@"Coordinates: %f, %f", coordinate.latitude, coordinate.longitude);
    }
    self.pointsAlongRoute = arrayCoordinates;
    compBlock();
    return arrayCoordinates;
}



-(void)displayPointsAlongRoute {
    
    for (int i=0; i<numStops; i++) {
        MKPointAnnotation* annotation= [MKPointAnnotation new];
        
        // retrieve coordinate from the array
        CLLocationCoordinate2D coordinate;
        [[self.pointsAlongRoute objectAtIndex:i] getValue:&coordinate];
        
        // add annotation for the coordinate
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
