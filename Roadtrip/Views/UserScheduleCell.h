//
//  UserScheduleCell.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/26/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"

@interface UserScheduleCell : UITableViewCell


@property (strong, nonatomic) Schedule *schedule;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;


@end
