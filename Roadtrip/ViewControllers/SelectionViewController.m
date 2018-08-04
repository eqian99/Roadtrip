//
//  SelectionViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SelectionViewController.h"
#import "selectEventsViewController.h"
#import "LocationTableViewController.h"
#import "SearchBarViewController.h"

@interface SelectionViewController ()<MySearchBarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property(assign, nonatomic)NSTimeInterval startOfDayUnix;
@property (assign, nonatomic)NSTimeInterval startOfEventsUnix;
@property(assign, nonatomic)NSTimeInterval endOfDayUnix;

@property (strong, nonatomic)UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *breakfastField;
@property (weak, nonatomic) IBOutlet UITextField *lunchField;
@property (weak, nonatomic) IBOutlet UITextField *dinnerField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *stateAndCountry;


@property (strong, nonatomic)NSCalendar *calendar;

@property (assign, nonatomic)NSTimeInterval breakfastTime;
@property (assign, nonatomic)NSTimeInterval lunchTime;
@property (assign, nonatomic)NSTimeInterval dinnerTime;

@end

@implementation SelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //City
    
    //Search controller setup
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tappedCityLabel:)];
    [self.cityLabel addGestureRecognizer:singleFingerTap];
    
    self.cityLabel.userInteractionEnabled = YES;
    
    //Date
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.dateField setInputView:datePicker];
    
    UIToolbar *toolBarStart=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarStart setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarStart setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.dateField setInputAccessoryView:toolBarStart];
    
    self.calendar = [NSCalendar currentCalendar];
    self.timePicker=[[UIDatePicker alloc]init];
    self.timePicker.datePickerMode=UIDatePickerModeTime;
    
    [self.breakfastField setInputView:self.timePicker];
    
    UIToolbar *toolBarBreakfast=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarBreakfast setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtnBfast=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showTimeBreakfast)];
    UIBarButtonItem *spaceBfast=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarBreakfast setItems:[NSArray arrayWithObjects:spaceBfast,doneBtnBfast, nil]];
    [self.breakfastField setInputAccessoryView:toolBarBreakfast];
    
    [self.lunchField setInputView:self.timePicker];
    UIToolbar *toolBarLunch=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarLunch setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtnLunch=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showTimeLunch)];
    UIBarButtonItem *spaceLunch=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarLunch setItems:[NSArray arrayWithObjects:spaceLunch,doneBtnLunch, nil]];
    [self.lunchField setInputAccessoryView:toolBarLunch];
    
    [self.dinnerField setInputView:self.timePicker];
    UIToolbar *toolBarDinner=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarLunch setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtnDinner=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showTimeDinner)];
    UIBarButtonItem *spaceDinner=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarDinner setItems:[NSArray arrayWithObjects:spaceDinner,doneBtnDinner, nil]];
    [self.dinnerField setInputAccessoryView:toolBarDinner];
    
    [self.startTimeField setInputView:self.timePicker];
    UIToolbar *toolBarStartTime=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBarBreakfast setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtnStartDay=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showStartDayTime)];
    UIBarButtonItem *spaceStartDay=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarStartTime setItems:[NSArray arrayWithObjects:spaceStartDay,doneBtnStartDay, nil]];
    [self.startTimeField setInputAccessoryView:toolBarStartTime];
}

- (void)changeCityText:(NSString *)cityString withStateAndCountry:(NSString *)stateAndCountry withLatitude:(NSString *)latitude withLongitude:(NSString *)longitude {

    self.cityLabel.text = cityString;
    
    self.cityLabel.textColor = [UIColor blackColor];
    
    //[self.cityLabel sizeToFit];
    
    self.city = cityString;
    self.stateAndCountry = stateAndCountry;
    self.latitude = latitude;
    self.longitude = longitude;
    
    PFQuery *query = [PFQuery queryWithClassName:@"City"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *cities, NSError *error) {
        if (cities != nil) {
            Boolean foundCity = NO;
            PFObject *foundParseCity = [PFObject objectWithClassName:@"City"];
            for(PFObject *parseCity in cities){
                [parseCity fetchIfNeeded];
                if([parseCity[@"name"] isEqualToString:self.city] && [parseCity[@"stateAndCountry"] isEqualToString:self.stateAndCountry]){
                    foundParseCity = parseCity;
                    foundCity = YES;
                    NSLog(@"FOUNDFOUND");
                    break;
                }
            }
            
            if(self.currUser == nil){
                self.currUser = [PFUser currentUser];
            }
            if(foundCity == NO){
                foundParseCity[@"latitude"] = self.latitude;
                foundParseCity[@"longitude"] = self.longitude;
                foundParseCity[@"name"] = self.city;
                foundParseCity[@"stateAndCountry"] = self.stateAndCountry;
                [foundParseCity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                    if(error) {
                        
                        NSLog(@"Error saving event from schedule");
                        
                        
                    } else {
                        NSArray *myCitiesArray = [self.currUser valueForKey:@"myCitiesSearched"];
                        NSMutableArray *citiesArrayMutable = [myCitiesArray mutableCopy];
                        [citiesArrayMutable insertObject:foundParseCity atIndex:0];
                        myCitiesArray = [citiesArrayMutable copy];
                        NSLog(@"%@", myCitiesArray);
                        [self.currUser setValue:myCitiesArray forKey:@"myCitiesSearched"];
                        [self.currUser saveInBackground];
                    }
                    
                }];
            }
            
            else{
                NSArray *myCitiesArray = [self.currUser valueForKey:@"myCitiesSearched"];
                NSMutableArray *citiesArrayMutable = [myCitiesArray mutableCopy];
                if(citiesArrayMutable == nil){
                    citiesArrayMutable = [NSMutableArray new];
                }
                for(int i = 0; i < citiesArrayMutable.count; i++){
                    PFObject *parseCity = citiesArrayMutable[i];
                    [parseCity fetchIfNeeded];
                    if([parseCity[@"name"] isEqualToString:self.city] && [parseCity[@"stateAndCountry"] isEqualToString:self.stateAndCountry]){
                        [citiesArrayMutable removeObjectAtIndex:i];
                    }
                }
                
                [citiesArrayMutable insertObject:foundParseCity atIndex:0];
                myCitiesArray = [citiesArrayMutable copy];
                NSLog(@"%@", myCitiesArray);
                [self.currUser setValue:myCitiesArray forKey:@"myCitiesSearched"];
                [self.currUser saveInBackground];
                
                // self.isMoreDataLoading = NO;
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (void)tappedCityLabel:(UITapGestureRecognizer *)recognizer{
    NSLog(@"tapped!");
    
    [self performSegueWithIdentifier:@"searchSegue" sender:nil];
    /*
    UISearchBar *searchBar = self.citySearchController.searchBar;
    
    [searchBar sizeToFit];
    
    searchBar.placeholder = @"Search for cities";
    
    self.navigationItem.titleView = self.citySearchController.searchBar;
    
    self.citySearchController.hidesNavigationBarDuringPresentation = false;
    
    self.citySearchController.dimsBackgroundDuringPresentation = true;
    
    self.definesPresentationContext = true;
     */
}

- (void) showStartDayTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.timePicker.date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    self.startOfEventsUnix = self.startOfDayUnix + hour * 60 * 60 + minute * 60 + second;
    
    NSLog(@"Breakfast time: %f", self.breakfastTime);
    NSLog(@"start of day: %f", self.startOfDayUnix);
    
    [formatter setDateFormat:@"hh:mm a"];
    self.startTimeField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.timePicker.date]];
    self.startTimeField.textColor = [UIColor blackColor];
    [self.startTimeField resignFirstResponder];
}

- (void)ShowSelectedDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MMM dd"];
    
    self.dateField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    self.dateField.textColor = [UIColor blackColor];
    [self.dateField resignFirstResponder];
    
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSDate *startOfDay = [calendar startOfDayForDate:datePicker.date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:1];
    [components setSecond:-1];
    
    NSDate *endOfDay = [calendar dateByAddingComponents:components toDate:startOfDay options:0];
    
    self.startOfDayUnix = [startOfDay timeIntervalSince1970];
    NSLog(@"%f", self.startOfDayUnix);
    
    self.endOfDayUnix = [endOfDay timeIntervalSince1970];
}

- (void)showTimeBreakfast{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.timePicker.date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    self.breakfastTime = self.startOfDayUnix + hour * 60 * 60 + minute * 60 + second;
    
    NSLog(@"Breakfast time: %f", self.breakfastTime);
    NSLog(@"start of day: %f", self.startOfDayUnix);
    
    [formatter setDateFormat:@"hh:mm a"];
    self.breakfastField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.timePicker.date]];
    self.breakfastField.textColor = [UIColor blackColor];
    [self.breakfastField resignFirstResponder];
}

- (void)showTimeLunch{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.timePicker.date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    self.lunchTime = self.startOfDayUnix + hour * 60 * 60 + minute * 60 + second;
    
    [formatter setDateFormat:@"hh:mm a"];
    self.lunchField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.timePicker.date]];
    self.lunchField.textColor = [UIColor blackColor];
    [self.lunchField resignFirstResponder];
}

- (void)showTimeDinner{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self.timePicker.date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    self.dinnerTime = self.startOfDayUnix + hour * 60 * 60 + minute * 60 + second;
    
    [formatter setDateFormat:@"hh:mm a"];
    self.dinnerField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.timePicker.date]];
    self.dinnerField.textColor = [UIColor blackColor];
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
    if([segue.identifier isEqualToString:@"selectActivitiesSegue"]){
        selectEventsViewController *selectEventsViewController = [segue destinationViewController];
        selectEventsViewController.latitude = [self.latitude doubleValue];
        selectEventsViewController.longitude = [self.longitude doubleValue];

        selectEventsViewController.city = self.city;
        selectEventsViewController.stateAndCountry = self.stateAndCountry;

        //Pass over data about the start time
        if(self.startOfEventsUnix == 0.0){
            self.startOfEventsUnix = self.startOfDayUnix;
        }
        selectEventsViewController.startOfDayUnix = self.startOfEventsUnix;
        selectEventsViewController.endOfDayUnix = self.endOfDayUnix;
        selectEventsViewController.breakfastUnixTime = self.breakfastTime;
        selectEventsViewController.lunchUnixTime = self.lunchTime;
        selectEventsViewController.dinnerUnixTime = self.dinnerTime;
        
        //Save user data
    }
    else if ([segue.identifier isEqualToString:@"searchSegue"]){
        SearchBarViewController *searchBarViewController = [segue destinationViewController];
        searchBarViewController.delegate = self;
    }
}


@end
