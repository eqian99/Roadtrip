//
//  SelectionViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SelectionViewController.h"

@interface SelectionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property(assign, nonatomic)NSTimeInterval startOfDayUnix;
@property(assign, nonatomic)NSTimeInterval endOfDayUnix;

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
    
    UIToolbar *toolBarEnd=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarEnd setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedEndDate)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarEnd setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    
    [self.dateField setInputAccessoryView:toolBarStart];
    [self.dateField setInputAccessoryView:toolBarEnd];
}

-(void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"dd/MMM/YYYY hh:min a"];
    
    self.dateField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.dateSelectionField resignFirstResponder];
    
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSDate *startOfDay = [calendar startOfDayForDate:datePicker.date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:1];
    [components setSecond:-1];
    
    NSDate *endOfDay = [calendar dateByAddingComponents:components toDate:startOfDay options:0];
    
    self.startOfDayUnix = [startOfDay timeIntervalSince1970];
    self.endOfDayUnix = [endOfDay timeIntervalSince1970];
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
