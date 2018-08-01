//
//  ShareScheduleViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/30/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface ScheduleMembersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *membersTableView;
@property (strong, nonatomic) Schedule *schedule;
@property (strong, nonatomic) NSArray *members;



@end
