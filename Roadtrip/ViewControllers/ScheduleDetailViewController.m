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

@interface ScheduleDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ScheduleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scheduleTableView.delegate = self;
    self.scheduleTableView.dataSource = self;
    self.scheduleTableView.rowHeight = 150;
    self.events = [NSMutableArray new];
    UIBarButtonItem *customBtn=[[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(didClickShareButton)];
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
                    [self.scheduleTableView reloadData];
                    
                } else if([[activity valueForKey:@"venueId"] isEqualToString:@"Meal"]){
                    
                    Event *meal = [Event new];
                    meal.name = name;
                    NSDate *startDate = [activity valueForKey:@"startDate"];
                    NSDate *endDate = [activity valueForKey:@"endDate"];
                    meal.startTimeUnixTemp = [startDate timeIntervalSince1970];
                    meal.endTimeUnixTemp = [endDate timeIntervalSince1970];
                    [self.events addObject:meal];
                    [self.scheduleTableView reloadData];
                    
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
                    [self.scheduleTableView reloadData];
                    
                }
            }
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
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.scheduleTableView indexPathForCell:tappedCell];
        EventDetailsViewController *eventDetailsViewController = [segue destinationViewController];
        eventDetailsViewController.activities = self.events;
        eventDetailsViewController.index = indexPath.row;
        
    } else if([[segue identifier] isEqualToString:@"shareScheduleSegue"]){
        ScheduleMembersViewController *viewController = [segue destinationViewController];
        viewController.schedule = self.schedule;
        
    }
    
    
}


@end
