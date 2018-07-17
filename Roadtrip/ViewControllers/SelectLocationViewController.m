//
//  SelectLocationViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SelectLocationViewController.h"
@interface SelectLocationViewController () <UINavigationControllerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@end

@implementation SelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    
    self.latitude=self.locationManager.location.coordinate.latitude;
    self.longitude=self.locationManager.location.coordinate.longitude;
    NSLog(@"%f%f", self.latitude, self.longitude);
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateSelectionField setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateSelectionField setInputAccessoryView:toolBar];
    
}

-(void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MMM/YYYY hh:min a"];
    self.dateSelectionField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.dateSelectionField resignFirstResponder];
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
