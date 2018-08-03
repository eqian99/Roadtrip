//
//  SchedulesViewController.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/26/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "SchedulesViewController.h"
#import "ScheduleDetailViewController.h"
#import "UserScheduleCell.h"
#import "Schedule.h"
#import "Parse.h"

@interface SchedulesViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SchedulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.schedulesTableView.delegate = self;
    self.schedulesTableView.dataSource = self;
    self.schedulesTableView.rowHeight = 200;
    self.schedules = [NSMutableArray new];
    [self fetchSchedulesFromParse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchSchedulesFromParse {
    
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *schedulesRelation = [currentUser relationForKey:@"schedules"];
    PFQuery *schedulesQuery = [schedulesRelation query];
    [schedulesQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error fetching schedules");
        } else {
            for(PFObject *parseSchedule in objects) {
                Schedule *schedule = [Schedule new];
                schedule.name = [parseSchedule valueForKey:@"name"];
                schedule.eventsRelation = [parseSchedule relationForKey:@"events"];
                schedule.membersRelation = [parseSchedule relationForKey:@"members"];
                schedule.createdDate = parseSchedule.createdAt;
                schedule.parseObject = parseSchedule;
                schedule.creator = [parseSchedule objectForKey:@"Creator"];
                schedule.scheduleDate = [parseSchedule objectForKey:@"date"];
                [self.schedules addObject:schedule];
                [self.schedulesTableView reloadData];
            }
            NSLog(@"Got schedules");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schedules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userScheduleCell" forIndexPath:indexPath];
    Schedule *schedule = self.schedules[indexPath.row];
    cell.nameLabel.text = schedule.name;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocalizedDateFormatFromTemplate:@"MMMMd"];
    NSLog(@"%@", [formatter stringFromDate:schedule.createdDate]);
    cell.dateLabel.text = [formatter stringFromDate:schedule.scheduleDate];
    cell.schedule = schedule;
    [cell.dateLabel sizeToFit];
    [cell.nameLabel sizeToFit];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"scheduleDetailSegue"]) {
        ScheduleDetailViewController *viewController = [segue destinationViewController];
        UserScheduleCell *cell = sender;
        Schedule *schedule = cell.schedule;
        viewController.schedule = schedule;
    }
    
}


@end
