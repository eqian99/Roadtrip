//
//  SavedScheduleViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/27/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "EventDetailsViewController.h"
#import "ScheduleMembersViewController.h"
#import "ScheduleEventCell.h"
#import "Parse.h"

#import "Landmark.h"
#import "Event.h"

@interface ScheduleDetailViewController () <UITableViewDelegate, UITableViewDataSource, MSWeekViewDelegate>

@end

@implementation ScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.podEvents = [NSMutableArray new];
    [self.scheduleView setDaysToShow:1];
    self.scheduleView.daysToShowOnScreen = 1;
    self.scheduleView.daysToShow = 0;
    self.scheduleView.delegate = self;
    
    self.events = [NSMutableArray new];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithTitle:@"Members" style:UIBarButtonItemStylePlain target:self action:@selector(didClickShareButton)];
    [self.navigationItem setRightBarButtonItem:customBtn];
    
    [self getEventsFromSchedule];
}
-(void) didClickShareButton {
    [self performSegueWithIdentifier:@"shareScheduleSegue" sender:self];
}
-(void) getEventsFromSchedule {
    PFRelation *eventsRelation = self.schedule.eventsRelation;
    PFQuery *eventsQuery = [eventsRelation query];
    [eventsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error getting events from schedule");
        } else {
            NSLog(@"Successfully fetched events from schedule");
            for(PFObject *activity in objects) {
                NSString *name = [activity valueForKey:@"name"];
                NSLog(@"%@" , name);
                if([[activity valueForKey:@"venueId"] isEqualToString:@"Landmark"]) {
                    Landmark *landmark = [Landmark new];
                    landmark.placeId = [activity valueForKey:@"eventId"];
                    landmark.name = name;
                    NSDate *startDate = [activity valueForKey:@"startDate"];
                    NSDate *endDate = [activity valueForKey:@"endDate"];
                    landmark.startTimeUnixTemp = [startDate timeIntervalSince1970];
                    landmark.endTimeUnixTemp = [endDate timeIntervalSince1970];
                    landmark.address = [activity valueForKey:@"address"];
                    [self.events addObject:landmark];
                    MSEvent *landmarkEvent = [MSEvent make:startDate end:endDate title:name subtitle:landmark.address];
                    [self.podEvents addObject:landmarkEvent];
                } else if([[activity valueForKey:@"venueId"] isEqualToString:@"Meal"]){
                    Event *meal = [Event new];
                    meal.name = name;
                    NSDate *startDate = [activity valueForKey:@"startDate"];
                    NSDate *endDate = [activity valueForKey:@"endDate"];
                    meal.startTimeUnixTemp = [startDate timeIntervalSince1970];
                    meal.endTimeUnixTemp = [endDate timeIntervalSince1970];
                    [self.events addObject:meal];
                    MSEvent *mealEvent = [MSEvent make:startDate end:endDate title:name subtitle:@"Restaurant"];
                    [self.podEvents addObject:mealEvent];
                } else {
                    Event *event = [Event new];
                    event.name = name;
                    event.eventId = [activity valueForKey:@"eventId"];
                    event.venueId = [activity valueForKey:@"valueId"];
                    NSDate *startDate = [activity valueForKey:@"startDate"];
                    NSDate *endDate = [activity valueForKey:@"endDate"];
                    event.startTimeUnixTemp = [startDate timeIntervalSince1970];
                    event.endTimeUnixTemp = [endDate timeIntervalSince1970];
                    event.address = [activity valueForKey:@"address"];
                    [self.events addObject:event];
                    MSEvent *msEvent = [MSEvent make:startDate end:endDate title:name subtitle: event.address];
                    [self.podEvents addObject:msEvent];
                    
                }
            }
            self.scheduleView.daysToShowOnScreen = 1;
            self.scheduleView.daysToShow = 0;
            NSArray *eventsForScheduleView = [self.podEvents copy];
            NSLog(@"Event #: %lu", eventsForScheduleView.count);
            self.scheduleView.events = eventsForScheduleView;
        }

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleEventCell" forIndexPath:indexPath];
    if([self.events[indexPath.row] isKindOfClass:[Event class]]) {
        Event *event = self.events[indexPath.row];
        [cell setScheduleCellEvent:event];
        NSLog(@"%f - %f", event.startTimeUnixTemp, event.endTimeUnixTemp);
    } else if([self.events[indexPath.row] isKindOfClass:[Landmark class]]) {
        [cell setScheduleCellLandmark:self.events[indexPath.row]];
    }
    return cell;
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"eventDetailSegue"]) {
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.activities = self.events;
        eventDetailsViewController.index = self.indexSelected;
    } else if([[segue identifier] isEqualToString:@"shareScheduleSegue"]){
        ScheduleMembersViewController *viewController = [segue destinationViewController];
        viewController.schedule = self.schedule;
    }
}
- (void)weekView:(id)sender eventSelected:(MSEventCell *)eventCell {
    
    MSEvent *event = eventCell.event;
    
    for(int i = 0; i < self.events.count; i++){
        if(self.podEvents[i] == event){
            self.indexSelected = i;
        }
    }
    [self performSegueWithIdentifier:@"eventDetailSegue" sender:self];
    
}




@end
