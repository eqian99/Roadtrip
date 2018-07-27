//
//  ScheduleViewController.h
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface ScheduleViewController : UIViewController

@property (strong, nonatomic) NSArray *eventsSelected;

@property(assign, nonatomic)NSTimeInterval startOfDayUnix;

@property(assign, nonatomic)NSTimeInterval endOfDayUnix;

@property (strong, nonatomic) NSString *city;


@end
