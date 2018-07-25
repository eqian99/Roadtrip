//
//  EventMapViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/20/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "EventMapViewController.h"
#import "Event.h"
#import "Landmark.h"
#import "EventbriteManager.h"

@interface EventMapViewController () <MKMapViewDelegate>

@end

@implementation EventMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    [self getCoordinatesOfEvents];
    
    [self populateMapWithLandmarks];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getCoordinatesOfEvents {
    
    for(Event *event in self.events) {
        
        NSString *venueId = event.venueId;
        
        NSLog(@"Venue Id: %@", venueId);
        
        [[EventbriteManager new] getVenueWithId:venueId completion:^(NSDictionary *venue, NSError *error) {
        
            if(venue) {
                
                NSString *latitude = venue[@"latitude"];
                
                NSString *longitude = venue [@"longitude"];
                
                NSString *address = venue[@"localized_address_display"];
                
                event.latitude = latitude;
                
                event.longitude = longitude;
                
                event.address = address;
                
                [self populateMapWithEvent:event];
                
                
            } else {
                
                NSLog(@"Error getting venue of event");
                
            }
            
        }];
        
    }
    
}

-(void) populateMapWithEvent: (Event *) event {
    
    double latitude = [event.latitude doubleValue];
    
    double longitude = [event.longitude doubleValue];
    
    NSLog(@"%f, %f", latitude, longitude);
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    
    annotation.coordinate = coordinate;
    
    annotation.title = event.name;
    
    [self.mapView addAnnotation:annotation];
    
}

-(void) populateMapWithLandmarks {
    
    for(int i = 0; i < self.landmarks.count ; i++) {
        
        Landmark *landmark = [self.landmarks objectAtIndex:i];
        
        double latitude = [landmark.latitude doubleValue];
        
        double longitude = [landmark.longitude doubleValue];
        
        NSLog(@"%f, %f", latitude, longitude);
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        
        annotation.coordinate = coordinate;
        
        annotation.title = landmark.name;
        
        [self.mapView addAnnotation:annotation];
        
    }
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in mapView.annotations) {
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        
        if (MKMapRectIsNull(zoomRect)) {
        
            zoomRect = pointRect;
        
        } else {
        
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        
        }
    
    }
    
    [mapView setVisibleMapRect:zoomRect animated:YES];
    
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
