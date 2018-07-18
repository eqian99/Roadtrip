//
//  SelectLocationViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SelectLocationViewController.h"
#import "CategoryViewController.h"
@interface SelectLocationViewController () <UINavigationControllerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property(assign, nonatomic)NSTimeInterval startOfDayUnix;
@property(assign, nonatomic)NSTimeInterval endOfDayUnix;
@property (nonatomic) BOOL hasSelectedLocation;
@property (strong, nonatomic) MKPointAnnotation *selectedLocationAnnotation;
@property (strong, nonatomic) NSString *city;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *useCurrentCityButton;
@end

@implementation SelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Map
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.latitude=self.locationManager.location.coordinate.latitude;
    self.longitude=self.locationManager.location.coordinate.longitude;
    NSLog(@"%f%f", self.latitude, self.longitude);
    
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    
    [self.mapView addGestureRecognizer:gestureRecognizer];
    
    self.hasSelectedLocation = false;
    
    self.useCurrentCityButton.enabled = false;
    
    //Get City
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation: self.locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return; // Request failed, log error
        }
        
        // Check if any placemarks were found
        if (placemarks && placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            
            NSString *city = placemark.locality;
            
            self.city = city;
            self.cityLabel.text = [NSString stringWithFormat:@"City: %@", city ];
            NSLog(@"%@", city);
        }

        
        
    }];
    
    
    //Date
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateSelectionField setInputView:datePicker];
    [self.endDateSelectionField setInputView:datePicker];
    
    UIToolbar *toolBarStart=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarStart setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarStart setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    UIToolbar *toolBarEnd=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarEnd setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedEndDate)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarEnd setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    
    [self.dateSelectionField setInputAccessoryView:toolBarStart];
    [self.endDateSelectionField setInputAccessoryView:toolBarEnd];
}

-(void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"dd/MMM/YYYY hh:min a"];
    self.dateSelectionField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.dateSelectionField resignFirstResponder];
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSDate *startOfDay = [calendar startOfDayForDate:datePicker.date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:2];
    [components setSecond:-1];
    NSDate *endOfDay = [calendar dateByAddingComponents:components toDate:startOfDay options:0];
    self.startOfDayUnix = [startOfDay timeIntervalSince1970];
    self.endOfDayUnix = [endOfDay timeIntervalSince1970];
}

-(void)ShowSelectedEndDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY hh:min a"];
    self.endDateSelectionField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.endDateSelectionField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedNext:(id)sender {
    
    [self performSegueWithIdentifier:@"eventCategoriesSegue" sender: self];
    
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    
    if(sender.state == UIGestureRecognizerStateEnded) {
        
        self.hasSelectedLocation = true;
        
    } else {
        
        if (self.hasSelectedLocation)
        {
            [self.mapView removeAnnotation:self.selectedLocationAnnotation];
            
        }
        
        
            // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:locCoord.latitude longitude:locCoord.longitude];

        MKPointAnnotation *annotation = [MKPointAnnotation new];
        
        annotation.coordinate = locCoord;
        
        [self.mapView addAnnotation:annotation];
        
        self.longitude = locCoord.longitude;
        self.latitude = locCoord.latitude;
        
        
        NSLog(@"Lat: %f Lon: %f", locCoord.latitude, locCoord.longitude);
        // Then all you have to do is create the annotation and add it to the map
        
        self.selectedLocationAnnotation = annotation;
        
        
        CLGeocoder *geocoder = [CLGeocoder new];
        
        [geocoder reverseGeocodeLocation: location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            
            if (error) {
                NSLog(@"Geocode failed with error: %@", error);
                return; // Request failed, log error
            }
            
            // Check if any placemarks were found
            if (placemarks && placemarks.count > 0)
            {
                CLPlacemark *placemark = placemarks[0];
                
                NSString *city = placemark.locality;
                
                self.city = city;
                
                self.cityLabel.text = [NSString stringWithFormat:@"City: %@", city ];
                
                self.useCurrentCityButton.enabled = true;
                
                NSLog(@"%@", city);
            }
            
            
            
        }];
        
    }

    
    
}
- (IBAction)didClickedUseCurrentCity:(id)sender {
    
    self.useCurrentCityButton.enabled = false;
    
    [self.mapView removeAnnotation:self.selectedLocationAnnotation];
    
    self.latitude=self.locationManager.location.coordinate.latitude;
    
    self.longitude=self.locationManager.location.coordinate.longitude;
    
    self.hasSelectedLocation = false;
    
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder reverseGeocodeLocation: self.locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
            return; // Request failed, log error
        }
        
        // Check if any placemarks were found
        if (placemarks && placemarks.count > 0)
        {
            CLPlacemark *placemark = placemarks[0];
            
            NSString *city = placemark.locality;
            
            self.city = city;
            self.cityLabel.text = [NSString stringWithFormat:@"City: %@", city ];
            NSLog(@"%@", city);
        }
        
        
        
    }];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CategoryViewController *categoryViewController = [segue destinationViewController];
    categoryViewController.latitude = self.latitude;
    categoryViewController.longitude = self.longitude;
    //Pass over data about the start time
    categoryViewController.startOfDayUnix = self.startOfDayUnix;
    categoryViewController.endOfDayUnix = self.endOfDayUnix;
}


@end
