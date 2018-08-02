//
//  ScheduleEventCell.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/27/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "ScheduleEventCell.h"

@implementation ScheduleEventCell

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
    
    [self.timeLabel sizeToFit];
    //NSLog(@"%@", event.address);
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
    [self.timeLabel sizeToFit];

}

@end
