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
    NSString *startEndDate = [NSString stringWithFormat:@"%@ - %@", event.startDate, event.endDate];
    self.startEndLabel.text = startEndDate;
    self.addressLabel.text = event.address;
}
@end
