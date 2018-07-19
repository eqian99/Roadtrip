//
//  SelectionViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SelectionViewController.h"
#import "selectEventsViewController.h"

@interface SelectionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property(assign, nonatomic)NSTimeInterval startOfDayUnix;
@property(assign, nonatomic)NSTimeInterval endOfDayUnix;
@property (strong, nonatomic)UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *breakfastField;
@property (weak, nonatomic) IBOutlet UITextField *lunchField;
@property (weak, nonatomic) IBOutlet UITextField *dinnerField;

@property (strong, nonatomic)NSCalendar *calendar;

@property (assign, nonatomic)NSTimeInterval breakfastTime;
@property (assign, nonatomic)NSTimeInterval lunchTime;
@property (assign, nonatomic)NSTimeInterval dinnerTime;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Date
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateField setInputView:datePicker];
    
    UIToolbar *toolBarStart=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarStart setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarStart setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.dateField setInputAccessoryView:toolBarStart];
    
    self.calendar = [NSCalendar currentCalendar];
    self.timePicker=[[UIDatePicker alloc]init];
    self.timePicker.datePickerMode=UIDatePickerModeTime;
    [self.breakfastField setInputView:self.timePicker];
    
    UIToolbar *toolBarBreakfast=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarBreakfast setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtnBfast=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showTimeBreakfast)];
    UIBarButtonItem *spaceBfast=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarBreakfast setItems:[NSArray arrayWithObjects:spaceBfast,doneBtnBfast, nil]];
    [self.breakfastField setInputAccessoryView:toolBarBreakfast];
    
    [self.lunchField setInputView:self.timePicker];
    UIToolbar *toolBarLunch=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarLunch setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtnLunch=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showTimeLunch)];
    UIBarButtonItem *spaceLunch=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarLunch setItems:[NSArray arrayWithObjects:spaceLunch,doneBtnLunch, nil]];
    [self.lunchField setInputAccessoryView:toolBarLunch];
    
    [self.dinnerField setInputView:self.timePicker];
    UIToolbar *toolBarDinner=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarLunch setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtnDinner=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showTimeDinner)];
    UIBarButtonItem *spaceDinner=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarDinner setItems:[NSArray arrayWithObjects:spaceDinner,doneBtnDinner, nil]];
    [self.dinnerField setInputAccessoryView:toolBarDinner];
}

-(void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"dd/MMM/YYYY hh:min a"];
    
    self.dateField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.dateField resignFirstResponder];
    
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSDate *startOfDay = [calendar startOfDayForDate:datePicker.date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:1];
    [components setSecond:-1];
    
    NSDate *endOfDay = [calendar dateByAddingComponents:components toDate:startOfDay options:0];
    
    self.startOfDayUnix = [startOfDay timeIntervalSince1970];
    self.endOfDayUnix = [endOfDay timeIntervalSince1970];
}

-(void)showTimeBreakfast{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.timePicker.date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    self.breakfastTime = self.startOfDayUnix + hour * 60 * 60 + minute * 60 + second;
    
    NSLog(@"%f", self.breakfastTime);
    
    [formatter setDateFormat:@"hh:min a"];
    self.breakfastField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.timePicker.date]];
    [self.breakfastField resignFirstResponder];
}

-(void)showTimeLunch{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.timePicker.date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    self.lunchTime = self.startOfDayUnix + hour * 60 * 60 + minute * 60 + second;
    
    [formatter setDateFormat:@"hh:min a"];
    self.lunchField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.timePicker.date]];
    [self.lunchField resignFirstResponder];
}

-(void)showTimeDinner{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.timePicker.date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    self.dinnerTime = self.startOfDayUnix + hour * 60 * 60 + minute * 60 + second;
    
    [formatter setDateFormat:@"hh:min a"];
    self.dinnerField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.timePicker.date]];
    [self.dinnerField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    selectEventsViewController *selectEventsViewController = [segue destinationViewController];
    //selectEventsViewController.latitude = self.latitude;
    //selectEventsViewController.longitude = self.longitude;
    //Pass over data about the start time
    selectEventsViewController.startOfDayUnix = self.startOfDayUnix;
    selectEventsViewController.endOfDayUnix = self.endOfDayUnix;

}


@end
