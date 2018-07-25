//
//  ScheduleCell.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/24/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleCell.h"

@implementation ScheduleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setScheduleCellEvent: (Event *)event{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm a"];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:event.startTimeUnixTemp];
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:event.endTimeUnixTemp];
    NSString *startTimeString = [formatter stringFromDate:startTime];
    NSString *endTimeString = [formatter stringFromDate:endTime];
    NSString *startEndTime = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
    self.timeLabel.text = startEndTime;
    self.nameLabel.text = event.name;
    self.addressLabel.text = event.address;
    NSLog(@"%@", event.address);
}

-(void) setScheduleCellLandmark: (Landmark *)landmark{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm a"];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:landmark.startTimeUnixTemp];
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:landmark.endTimeUnixTemp];
    NSString *startTimeString = [formatter stringFromDate:startTime];
    NSString *endTimeString = [formatter stringFromDate:endTime];
    NSString *startEndTime = [NSString stringWithFormat:@"%@ - %@", startTimeString, endTimeString];
    self.timeLabel.text = startEndTime;
    self.nameLabel.text = landmark.name;
    self.addressLabel.text = landmark.address;
}

@end
