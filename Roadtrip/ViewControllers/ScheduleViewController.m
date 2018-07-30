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

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    self.eventsSelected = [Event sortEventArrayByStartDate:self.eventsSelected];

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
    UITableViewCell *tappedCell = sender;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
    EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
    
    eventDetailsViewController.activities = self.eventsSelected;
    
    eventDetailsViewController.index = indexPath.row;
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
    
    PFRelation *scheduleRelation = [[PFUser currentUser] relationForKey:@"schedules"];
    
    PFObject *schedule = [PFObject objectWithClassName:@"Schedule"];
    
    [schedule setValue:self.city forKey:@"name"];
    
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
                            
                            parseEvent[@"startDate"] = event.startDate;
                            
                            parseEvent[@"endDate"] = event.endDate;
                            
                            parseEvent[@"venueId"] = event.venueId;
                            
                            parseEvent[@"eventId"] = event.eventId;
                            
                        } else {
                            
                            parseEvent[@"startDate"] = [NSDate dateWithTimeIntervalSince1970:event.startTimeUnix];
                            
                            parseEvent[@"endDate"] = [NSDate dateWithTimeIntervalSince1970:event.endTimeUnix];
                            
                            parseEvent[@"venueId"] = @"Meal";
                            
                            parseEvent[@"eventId"] = @"Meal";
                            
                        }
                        
                        
                    } else if ([self.eventsSelected[i] isKindOfClass:[Landmark class]]) {
                        
                        Landmark *landmark = self.eventsSelected[i];
                        
                        NSLog(@"Start Time Unix Temp for Landmark: %f" , landmark.startTimeUnixTemp);
                        NSLog(@"Start of day unix: %f", self.startOfDayUnix);
                        
                        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970: landmark.startTimeUnixTemp];
                        
                        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:landmark.endTimeUnixTemp];
                        
                        parseEvent[@"startDate"] = startDate;
                        
                        parseEvent[@"endDate"] = endDate;
                        
                        parseEvent[@"name"] = landmark.name;
                        
                        parseEvent[@"eventId"] = landmark.placeId;
                        
                        parseEvent[@"venueId"] = @"Landmark";
                        
                    }

                    
                    [parseEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        if(error) {
                            
                            NSLog(@"Error saving event from schedule");
                            
                            
                        } else {
                            
                            NSLog(@"Success saving event from schedule in parse");
                            
                            [events addObject:parseEvent];
                            
                            [schedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                if(error) {
                                    NSLog(@"Error saving schedule after adding events in events relation");
                                } else {
                                    NSLog(@"Success?");
                                    [self createAlert:@"Schedule saved"];
                                }
                            }];

                            
                        }
                        
                    }];
                    
                    
                }
            
            
        }
        
        
    }];
    
    
    
//    PFRelation *events = [schedule relationForKey:@"events"];
    
//
//    for(int i = 0; i < self.eventsSelected.count; i++) {
//
//        Event *event = self.eventsSelected[i];
//        PFObject *parseEvent = [PFObject objectWithClassName:@"Event"];
//
//        parseEvent[@"startDate"] = event.startDate;
//        parseEvent[@"endDate"] = event.endDate;
//        parseEvent[@"name"] = event.name;
//        parseEvent[@"venueId"] = event.venueId;
//        parseEvent[@"eventId"] = event.eventId;
//
//        [events addObject:parseEvent];
//
//    }
//
//
//    [scheduleRelation addObject:schedule];
//
//    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//
//
//        if (error) {
//
//            NSLog(@"%@ %@", error, [error userInfo]);
//
//        } else {
//
//            NSLog(@"Current user saved In Background");
//
//        }
//
//
//    }];
    
    
}

 


@end
