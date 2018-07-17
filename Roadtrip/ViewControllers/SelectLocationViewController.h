//
//  SelectLocationViewController.h
//  Roadtrip
//
//  Created by Emma Qian on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface SelectLocationViewController : UIViewController
@property (strong, nonatomic) NSArray * categories;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
