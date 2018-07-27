//
//  SavedScheduleViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/27/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface ScheduleDetailViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITableView *scheduleTableView;

@property (strong, nonatomic) NSMutableArray *events;

@property (strong, nonatomic) Schedule *schedule;

@end
