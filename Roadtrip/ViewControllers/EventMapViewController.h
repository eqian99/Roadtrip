//
//  EventMapViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/20/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EventMapViewController : UIViewController


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSArray *events;



@end
