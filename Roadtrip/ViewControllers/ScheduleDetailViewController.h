//
//  SavedScheduleViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/27/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "MSWeekViewDecoratorFactory.h"


@interface ScheduleDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet MSWeekView *scheduleView;
@property (strong, nonatomic) MSWeekView *decoratedWeekView;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *podEvents;
@property (strong, nonatomic) NSMutableArray *restaurants;
@property (strong, nonatomic) Schedule *schedule;
@property (assign, nonatomic)NSInteger indexSelected;

@end
