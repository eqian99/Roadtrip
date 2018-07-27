//
//  SavedScheduleViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/27/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleDetailViewController.h"
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
    
    [self getEventsFromSchedule];
    
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
                    
                    NSLog(@"Landmark");
                    
                    Landmark *landmark = [Landmark new];
                    
                    landmark.placeId = [activity valueForKey:@"eventId"];
                    
                    landmark.name = name;
                    
                    [self.events addObject:landmark];
                    
                    [self.scheduleTableView reloadData];
                    
                    
                } else if([[activity valueForKey:@"venueId"] isEqualToString:@"Meal"]){
                    
                    NSLog(@"Meal");
                    
                    Event *meal = [Event new];
                    
                    meal.name = name;
                    
                    [self.events addObject:meal];
                    
                    [self.scheduleTableView reloadData];

                    
                } else {
                    
                    NSLog(@"Event");
                    
                    Event *event = [Event new];
                    
                    event.name = name;
                    
                    event.eventId = [activity valueForKey:@"eventId"];
                    
                    event.venueId = [activity valueForKey:@"valueId"];
                    
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
        
        cell.nameLabel.text = event.name;
        
    } else if([self.events[indexPath.row] isKindOfClass:[Landmark class]]) {
        
        Landmark *landmark = self.events[indexPath.row];
        
        
        cell.nameLabel.text = landmark.name;
        
        
    }
    
    return cell;
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
