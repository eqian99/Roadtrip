//
//  ScheduleViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Event.h"
#import "Landmark.h"
#import "ScheduleCell.h"
#import "EventDetailsViewController.h"
#import "Parse.h"
#import <EventKit/EventKit.h>
#import "YelpManager.h"
#import "RestaurantChooserViewController.h"
#import "MSWeekViewDecoratorFactory.h"
#import "MBProgressHUD.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, RestaurantChooserViewControllerDelegate, MSWeekViewDelegate>


@property (weak, nonatomic) IBOutlet MSWeekView *scheduleView;
@property (strong, nonatomic) MSWeekView *decoratedWeekView;

@property (strong, nonatomic) NSMutableArray *restaurants;
@property (assign, nonatomic)long index;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.podEvents = [NSMutableArray new];
    self.decoratedWeekView = [MSWeekViewDecoratorFactory make:self.scheduleView
                                                     features:(MSDragableEventFeature | MSChangeDurationFeature)
                                                  andDelegate:self];
    
    [self.scheduleView setDaysToShow:1];
    self.scheduleView.weekFlowLayout.show24Hours = YES;
    self.scheduleView.daysToShowOnScreen = 1;
    self.scheduleView.daysToShow = 0;
    self.scheduleView.delegate = self;
    
    self.eventsSelected = [Event sortEventArrayByStartDate:self.eventsSelected];
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self populateScheduleView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateScheduleView {
    for(int i = 0; i < self.eventsSelected.count; i++){
        if([self.eventsSelected[i] isKindOfClass:[Event class]]){
            Event *event = self.eventsSelected[i];
            
            if(event.isMeal) {
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:event.startTimeUnixTemp];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:event.endTimeUnixTemp];
                MSEvent *mealEvent = [MSEvent make:startDate end:endDate title:event.name subtitle: @"Restaurant"];
                [self.podEvents addObject:mealEvent];
                
            } else if(event.isGoogleEvent) {
                
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:event.startTimeUnixTemp];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:event.endTimeUnixTemp];
                MSEvent *googleEvent = [MSEvent make:startDate end:endDate title:event.name subtitle: event.address];
                [self.podEvents addObject:googleEvent];
                
            } else {
                
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:event.startTimeUnixTemp];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:event.endTimeUnixTemp];
                MSEvent *msEvent = [MSEvent make:startDate end:endDate title:event.name subtitle: event.address];
                [self.podEvents addObject: msEvent];
                
            }
            
        }
        else{
            
            Landmark *landmark = self.eventsSelected[i];
            
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:landmark.startTimeUnixTemp];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:landmark.endTimeUnixTemp];
            MSEvent *landmarkEvent = [MSEvent make:startDate end:endDate title:landmark.name subtitle: landmark.address];
            [self.podEvents addObject: landmarkEvent];
            
        }
    }
    
    self.scheduleView.daysToShowOnScreen = 1;
    self.scheduleView.daysToShow = 0;
    NSArray *eventsForScheduleView = [self.podEvents copy];
    NSLog(@"Event #: %lu", eventsForScheduleView.count);
    self.scheduleView.events = eventsForScheduleView;
    
}


- (void)weekView:(id)sender eventSelected:(MSEventCell *)eventCell {
    MSEvent *event = eventCell.event;
    for(int i = 0; i < self.eventsSelected.count; i++){
        if(self.podEvents[i] == event){
            self.index = i;
        }
    }
    [self performSegueWithIdentifier:@"detailsSegue" sender:self];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.index = indexPath.row;
    if([self.eventsSelected[indexPath.row] isKindOfClass:[Event class]] && ((Event *)self.eventsSelected[indexPath.row]).isMeal){
        Event *myEvent = self.eventsSelected[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        double latitude;
        double longitude;
        if(self.eventsSelected.count == 0){
            latitude = self.latitude;
            longitude = self.longitude;
            myEvent.latitude = [NSString stringWithFormat:@"%f", latitude];
            myEvent.longitude = [NSString stringWithFormat:@"%f", longitude];
        }
        if(self.index == 0){
            Event *nextEvent = self.eventsSelected[1];
            latitude = [nextEvent.latitude doubleValue];
            longitude = [nextEvent.longitude doubleValue];
            myEvent.latitude = [NSString stringWithFormat:@"%f", latitude];
            myEvent.longitude = [NSString stringWithFormat:@"%f", longitude];
        }
        else if(self.index == self.eventsSelected.count){
            Event *prevEvent = self.eventsSelected[self.eventsSelected.count - 2];
            latitude = [prevEvent.latitude doubleValue];
            longitude = [prevEvent.longitude doubleValue];
            myEvent.latitude = [NSString stringWithFormat:@"%f", latitude];
            myEvent.longitude = [NSString stringWithFormat:@"%f", longitude];
        }
        else{
            Event *prevEvent = self.eventsSelected[indexPath.row - 1];
            latitude = [prevEvent.latitude doubleValue];
            longitude = [prevEvent.longitude doubleValue];
            myEvent.latitude = [NSString stringWithFormat:@"%f", latitude];
            myEvent.longitude = [NSString stringWithFormat:@"%f", longitude];
        }
        
        NSArray *categories;
        if(myEvent.isBreakfast){
            categories = @[@"danish", @"congee", @"bagels", @"coffee"];
        }
        else{
            categories = @[@"burgers", @"chinese", @"buffets", @"chicken_wings", @"flatbread", @"food_cout", @"french", @"japanese", @"korean", @"jewish", @"kebab", @"mexican", @"pizza"];
        }
        [[YelpManager new]getRestaurantsWithLatitude:latitude withLongitude:longitude withCategories:categories withCompletion:^(NSArray *restaurantsArray, NSError *error) {
            if(error){
                NSLog(@"error");
            }
            else{
                self.restaurants = [NSMutableArray new];
                int numRestaurants;
                if(restaurantsArray.count < 10){
                    numRestaurants = (int)restaurantsArray.count;
                }
                else{
                    numRestaurants = 10;
                }
                NSMutableArray *restaurantNames = [NSMutableArray new];
                
                // add first 10 restaurants
                for(int i = 0; i < numRestaurants; i++){
                    // make sure no duplicate restaurants
                    if([restaurantNames indexOfObject:restaurantsArray[i][@"name"]] == NSNotFound){
                        [self.restaurants addObject:restaurantsArray[i]];
                        [restaurantNames addObject:restaurantsArray[i][@"name"]];
                    }
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self performSegueWithIdentifier:@"foodSegue" sender:nil];
            }
        }];
    }
    else{
        [self performSegueWithIdentifier:@"detailsSegue" sender:nil];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if([segue.identifier isEqualToString:@"detailsSegue"]){
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.activities = self.eventsSelected;
        eventDetailsViewController.index = self.index;
    }
    else{
        RestaurantChooserViewController *restaurantChooser = [segue destinationViewController];
        restaurantChooser.restaurants = self.restaurants;
        restaurantChooser.delegate = self;
        restaurantChooser.index = (int)self.index;
    }
}

-(void)weekView:(MSWeekView *)weekView event:(MSEvent *)event moved:(NSDate *)date{
    NSLog(@"Event moved");
    NSLog(@"%@", date);
}

-(BOOL)weekView:(MSWeekView*)weekView canStartMovingEvent:(MSEvent*)event{
    NSLog(@"%@", event.title);
    for(int i = 0; i < self.eventsSelected.count; i++){
        NSLog(@"in here");
        if([self.eventsSelected[i] isKindOfClass:[Event class]]){
            Event *myEvent = self.eventsSelected[i];
            if([event.title isEqualToString:myEvent.name]){
                NSLog(@"found it");
                if(myEvent.isFlexible == NO){
                    NSLog(@"%i", myEvent.isFlexible);
                    NSLog(@"not flexible");
                    return NO;
                }
                return YES;
            }
        }
    }
    return YES;
}

-(BOOL)weekView:(MSWeekView *)weekView canMoveEvent:(MSEvent *)event to:(NSDate *)date{
    for(int i = 0; i < self.eventsSelected.count; i++){
        if([self.eventsSelected[i] isKindOfClass:[Event class]]){
            Event *myEvent = self.eventsSelected[i];
            if([event.title isEqualToString:myEvent.name]){
                if(myEvent.isFlexible == NO){
                    return NO;
                }
                return YES;
            }
        }
    }
    return YES;
    
    //Example on how to return YES/NO from an async function (for example an alert)
    /*NSCondition* condition = [NSCondition new];
     BOOL __block shouldMove;
     
     RVAlertController* a = [RVAlertController alert:@"Move"
     message:@"Do you want to move";
     
     
     [a showAlertWithCompletion:^(NSInteger buttonIndex) {
     shouldMove = (buttonIndex == RVALERT_OK);
     [condition signal];
     }];
     
     [condition lock];
     [condition wait];
     [condition unlock];
     
     return shouldMove;*/
}

-(BOOL)weekView:(MSWeekView*)weekView canChangeDuration:(MSEvent*)event startDate:(NSDate*)startDate endDate:(NSDate*)endDate{
     NSLog(@"%@", event.title);
     for(int i = 0; i < self.eventsSelected.count; i++){
     NSLog(@"in here");
     if([self.eventsSelected[i] isKindOfClass:[Event class]]){
     Event *myEvent = self.eventsSelected[i];
     if([event.title isEqualToString:myEvent.name]){
     NSLog(@"found it");
     if(!myEvent.isFlexible){
     NSLog(@"not flexible");
     return NO;
     }
     return YES;
     }
     }
     }
     return YES;
}
-(void)weekView:(MSWeekView*)weekView event:(MSEvent*)event durationChanged:(NSDate*)startDate endDate:(NSDate*)endDate{
    NSLog(@"Changed event duration");
    NSLog(@"%@", endDate);
    for(int i = 0; i < self.eventsSelected.count; i++){
        if([self.eventsSelected[i] isKindOfClass:[Event class]]){
            Event *myEvent = self.eventsSelected[i];
            if([myEvent.name isEqualToString:event.title]){
                myEvent.startDate = startDate;
                myEvent.endDate = endDate;
                myEvent.startTimeUnix = [startDate timeIntervalSince1970];
                myEvent.endTimeUnix = [endDate timeIntervalSince1970];
                myEvent.startTimeUnixTemp = [startDate timeIntervalSince1970];
                myEvent.endTimeUnixTemp = [endDate timeIntervalSince1970];
            }
        }
        else{
            Landmark *myLandmark = self.eventsSelected[i];
            if([myLandmark.name isEqualToString:event.title]){
                NSLog(@"Found the landmark");
                myLandmark.startTimeUnixTemp = [startDate timeIntervalSince1970];
                myLandmark.endTimeUnixTemp = [endDate timeIntervalSince1970];
            }
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ScheduleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell"];
    if([self.eventsSelected[indexPath.row] isKindOfClass:[Event class]]){
        [cell setScheduleCellEvent:self.eventsSelected[indexPath.row]];
    }
    else{
        [cell setScheduleCellLandmark:self.eventsSelected[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsSelected.count;
}
- (IBAction)tappedImportSchedule:(id)sender {
    
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        for(int i = 0; i < self.eventsSelected.count; i++){
            
            EKEvent *event = [EKEvent eventWithEventStore:store];
            if([self.eventsSelected[i] isKindOfClass:[Event class]]){
                Event *myEvent = self.eventsSelected[i];
                event.title = myEvent.name;
                NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:myEvent.startTimeUnixTemp];
                NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:myEvent.endTimeUnixTemp];
                event.startDate = startTime;
                event.endDate = endTime;
                event.calendar = [store defaultCalendarForNewEvents];
                NSError *err = nil;
                [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            }
            else{
                Landmark *myLandmark = self.eventsSelected[i];
                event.title = myLandmark.name;
                NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:myLandmark.startTimeUnixTemp];
                NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:myLandmark.endTimeUnixTemp];
                event.startDate = startTime;
                event.endDate = endTime;
                event.calendar = [store defaultCalendarForNewEvents];
                NSError *err = nil;
                [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            }
        }
    }];
    
}

- (void)createAlert:(NSString *)errorMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                   message:errorMessage
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (IBAction)tappedSaveSchedule:(id)sender {
    
    if(self.saved == false) {
        [self saveSchedule];
        self.saved = true;
    } else {
        [self showScheduleAlreadySavedAlert];
    }
}


-(void) saveSchedule {
    
    PFRelation *scheduleRelation = [[PFUser currentUser] relationForKey:@"schedules"];
    PFObject *schedule = [PFObject objectWithClassName:@"Schedule"];
    [schedule setValue:self.city forKey:@"name"];
    NSDate *scheduleDate = [NSDate dateWithTimeIntervalSince1970:self.startOfDayUnix];
    [schedule setValue:scheduleDate forKey:@"date"];
    [schedule setObject:[PFUser currentUser] forKey:@"Creator"];
    [schedule setValue:self.photoReference forKey:@"photoReference"];
    [schedule setValue: [NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    [schedule setValue:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    PFRelation *scheduleMembersRelation = [schedule relationForKey:@"members"];
    [scheduleMembersRelation addObject:[PFUser currentUser]];
    [schedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [scheduleRelation addObject:schedule];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error) {
                NSLog(@"Error saving user after adding schedule to schedule relation");
            } else {
                NSLog(@"Successfully saved user");
            }
        }];
        if(error) {
            NSLog(@"Error saving schedule");
        } else {
            PFRelation *events = [schedule relationForKey:@"events"];
            for(int i = 0; i < self.eventsSelected.count; i++) {
                PFObject *parseEvent = [PFObject objectWithClassName:@"Event"];
                if([self.eventsSelected[i] isKindOfClass:[Event class]]) {
                    
                    Event *event = self.eventsSelected[i];
                    parseEvent[@"name"] = event.name;
                    NSLog(@"%@", event.name);
                    
                    if(event.eventDescription) {
                        
                        
                        if(!event.isGoogleEvent){
                            
                            parseEvent[@"startDate"] = event.startDate;
                            parseEvent[@"endDate"] = event.endDate;
                            parseEvent[@"venueId"] = event.venueId;
                            parseEvent[@"eventId"] = event.eventId;
                            parseEvent[@"address"] = event.address;
                            parseEvent[@"description"] = event.eventDescription;
                            parseEvent[@"photoReference"] = event.photoReference;
                            
                            parseEvent[@"isGoogleEvent"] = [NSNumber numberWithBool:NO];
                            parseEvent[@"isMeal"] = [NSNumber numberWithBool:NO];
                            parseEvent[@"isLandmark"] = [NSNumber numberWithBool:NO];
                            parseEvent[@"isEvent"] = [NSNumber numberWithBool:YES];
                            
                        }
                        else{
                            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: event.startTimeUnixTemp];
                            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:event.endTimeUnixTemp];
                            parseEvent[@"startDate"] = startDate;
                            parseEvent[@"endDate"] = endDate;
                            parseEvent[@"name"] = event.name;
                            parseEvent[@"address"] = event.address;
                            parseEvent[@"description"] = @"No description";
                            parseEvent[@"photoReference"] = event.photoReference;
                            
                            parseEvent[@"isGoogleEvent"] = [NSNumber numberWithBool:YES];
                            parseEvent[@"isMeal"] = [NSNumber numberWithBool:NO];
                            parseEvent[@"isLandmark"] = [NSNumber numberWithBool:NO];
                            parseEvent[@"isEvent"] = [NSNumber numberWithBool:NO];
                        }
                        
                    } else {
                        
                        parseEvent[@"startDate"] = [NSDate dateWithTimeIntervalSince1970:event.startTimeUnix];
                        parseEvent[@"endDate"] = [NSDate dateWithTimeIntervalSince1970:event.endTimeUnix];
                        parseEvent[@"venueId"] = @"Meal";
                        parseEvent[@"eventId"] = @"Meal";
                        parseEvent[@"description"] = @"Meal";
                        
                        parseEvent[@"isGoogleEvent"] = [NSNumber numberWithBool:NO];
                        parseEvent[@"isMeal"] = [NSNumber numberWithBool:YES];
                        parseEvent[@"isLandmark"] = [NSNumber numberWithBool:NO];
                        parseEvent[@"isEvent"] = [NSNumber numberWithBool:NO];

                        
                    }
                    
                } else if ([self.eventsSelected[i] isKindOfClass:[Landmark class]]) {
                    
                    Landmark *landmark = self.eventsSelected[i];
                    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: landmark.startTimeUnixTemp];
                    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:landmark.endTimeUnixTemp];
                    parseEvent[@"startDate"] = startDate;
                    parseEvent[@"endDate"] = endDate;
                    parseEvent[@"name"] = landmark.name;
                    parseEvent[@"eventId"] = landmark.placeId;
                    parseEvent[@"venueId"] = @"Landmark";
                    parseEvent[@"address"] = landmark.address;
                    parseEvent[@"description"] = @"No description";
                    parseEvent[@"photoReference"] = landmark.photoReference;
                    parseEvent[@"rating"] = landmark.rating;
                    
                    parseEvent[@"isGoogleEvent"] = [NSNumber numberWithBool:NO];
                    parseEvent[@"isMeal"] = [NSNumber numberWithBool:NO];
                    parseEvent[@"isLandmark"] = [NSNumber numberWithBool:YES];
                    parseEvent[@"isEvent"] = [NSNumber numberWithBool:NO];
                }
                
                [parseEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error) {
                        NSLog(@"Error saving event from schedule");
                    } else {
                        [events addObject:parseEvent];
                        [schedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if(error) {
                                NSLog(@"Error saving schedule after adding events in events relation");
                            } else {
                                
                                [self createAlert:@"Schedule saved"];

                            }
                        }];
                        
                    }
                    
                }];
                
            }
        }
        
    }];
    
}

-(void) showScheduleAlreadySavedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This schedule is already saved!" message:@"This schedule has not been changed" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler: nil];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

/*
 for(int i = 0; i < self.eventsSelected.count; i++){
 if([self.eventsSelected[i] isKindOfClass:[Event class]]){
 Event * myEvent = self.eventsSelected[i];
 if([myEvent.name isEqualToString:@"Breakfast"] || [myEvent.name isEqualToString:@"Lunch"] || [myEvent.name isEqualToString:@"Dinner"]){
 [[YelpManager new]getRestaurantsWithLatitude:self.latitude withLongitude:self.longitude withCompletion:^(NSArray *restaurantsArray, NSError *error) {
 if(error){
 NSLog(@"There was an error");
 }
 else{
 NSLog(@"%@", restaurantsArray);
 NSDictionary *restaurantsDict = restaurantsArray[0];
 myEvent.name = restaurantsDict[@"name"];
 [self.tableView reloadData];
 }
 }];
 }
 }
 }
 */


-(void) didSave:(int)index withName:(NSString *)name withAddress:(NSString *)address{
    [self createAlert:@"Your restaurant has been saved to your schedule"];
    Event *myEvent = self.eventsSelected[index];
    myEvent.name = name;
    myEvent.address = address;
}


@end
