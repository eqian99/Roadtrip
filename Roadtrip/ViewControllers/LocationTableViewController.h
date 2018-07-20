//
//  LocationTableViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SelectLocationViewController.h"

@protocol CityDelegate

-(void) changeCityText: (NSString *) cityString withLatitude: (NSString *) latitude withLongitude: (NSString *) longitude;

@end

@interface LocationTableViewController : UITableViewController

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray *citiesArray;
@property (nonatomic, strong) NSArray *secondaryArray;
@property (nonatomic, strong) NSArray *latitudes;
@property (nonatomic, strong) NSArray *longitudes;

@property (weak, nonatomic) id<CityDelegate> cityDelegate;



@end


