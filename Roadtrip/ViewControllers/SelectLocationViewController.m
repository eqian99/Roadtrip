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
