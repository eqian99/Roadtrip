//
//  ScheduleEventCell.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/27/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "Event.h"
#import "Landmark.h"

@interface ScheduleEventCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

-(void) setScheduleCellEvent: (Event *)event;
-(void) setScheduleCellLandmark: (Landmark *)landmark;
@end
