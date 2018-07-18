//
//  RestaurantTimeViewController.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "RestaurantTimeViewController.h"

@interface RestaurantTimeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *breakfastField;
@property (weak, nonatomic) IBOutlet UITextField *lunchField;
@property (weak, nonatomic) IBOutlet UITextField *dinnerField;
@property (strong, nonatomic)UIDatePicker *datePicker;
@end

@implementation RestaurantTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker=[[UIDatePicker alloc]init];
    self.datePicker.datePickerMode=UIDatePickerModeTime;
    [self.breakfastField setInputView:self.datePicker];
    
    UIToolbar *toolBarStart=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarStart setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showTimeBreakfast)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarStart setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.breakfastField setInputAccessoryView:toolBarStart];
    
    [self.lunchField setInputView:self.datePicker];
    /*
    UIToolbar *toolBarStart=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarStart setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showTimeBreakfast)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarStart setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.breakfastField setInputAccessoryView:toolBarStart];
    */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showTimeBreakfast{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"hh:min a"];
    self.breakfastField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    [self.breakfastField resignFirstResponder];
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSDate *startOfDay = [calendar startOfDayForDate:self.datePicker.date];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:2];
    [components setSecond:-1];
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
