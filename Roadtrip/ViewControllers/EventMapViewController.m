//
//  EventMapViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/20/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "EventMapViewController.h"
#import "Event.h"

@interface EventMapViewController () <MKMapViewDelegate>

@end

@implementation EventMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    [self populateMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) populateMap {
    
    NSLog(@"Events count: %lu", self.events.count);
    
    for(Event *event in self.events) {
        
        double latitude = [event.latitude doubleValue];
        double longitude = [event.longitude doubleValue];
        
        NSLog(@"%f, %f", latitude, longitude);
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        
        annotation.coordinate = coordinate;
        
        annotation.title = event.name;
        
        [self.mapView addAnnotation:annotation];
        
        
    }
    
    
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
