//
//  EventCell.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEvent:(Event *)event{
    
    _event = event;
    self.nameLabel.text = event.name;
    self.descriptionLabel.text = event.eventDescription;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"E MMM d HH:mm Z y";
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    NSString *startDateString = [formatter stringFromDate:event.startDate];
    NSString *endDateString = [formatter stringFromDate:event.endDate];
    if([startDateString isEqualToString:endDateString]){
        [formatter setDateFormat:@"hh:mm a"];
        [formatter setAMSymbol:@"AM"];
        [formatter setPMSymbol:@"PM"];
        NSString *startTimeString = [formatter stringFromDate:event.startDate];
        NSString *endTimeString = [formatter stringFromDate:event.endDate];
        NSString *startEndTime = [NSString stringWithFormat:@"%@ %@ - %@", startDateString, startTimeString, endTimeString];
        self.startEndLabel.text = startEndTime;
    }
    else{
        NSString *startEndDate = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
        self.startEndLabel.text = startEndDate;
    }
    
    
    NSString *startEndDate = [NSString stringWithFormat:@"%@ - %@", event.startDate, event.endDate];
    self.startEndLabel.text = startEndDate;

    self.addressLabel.text = event.address;
}

-(void)setLandmark:(Landmark *)landmark{
    _landmark = landmark;
    
    self.nameLabel.text = landmark.name;
    
    self.addressLabel.text = landmark.address;
    self.descriptionLabel.text = @"No event description available";
    self.startEndLabel.text = @"";
}
@end
