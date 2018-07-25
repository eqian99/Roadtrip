//
//  ScheduleCell.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/24/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Landmark.h"

@interface ScheduleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

-(void) setScheduleCellEvent: (Event *)event;
-(void) setScheduleCellLandmark: (Landmark *)landmark;

@end
