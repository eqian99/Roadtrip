//
//  LandmarkCell.m
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "LandmarkCell.h"


@implementation LandmarkCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}

-(void)setlandmark:(Landmark *)landmark{
    
    _lankmark = landmark;
    
    self.nameLabel.text = landmark.name;
    
    self.addressLabel.text = landmark.address;
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%@", landmark.rating];
    
}

@end
