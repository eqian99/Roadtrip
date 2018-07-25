//
//  ScheduleViewController.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Event.h"
#import "ScheduleCell.h"
#import "EventDetailsViewController.h"
#import <EventKit/EventKit.h>

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.eventsSelected = [Event sortEventArrayByStartDate:self.eventsSelected];
    [self.tableView reloadData];

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
        [cell setScheduleCellEvent:self.eventsSelected[indexPath.row]];
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
 


@end
