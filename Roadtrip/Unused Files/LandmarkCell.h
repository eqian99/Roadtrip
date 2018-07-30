//
//  LandmarkCell.h
//  Roadtrip
//
//  Created by Emma Qian on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Landmark.h"


@interface LandmarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (strong, nonatomic)Landmark *landmark;

-(void)setLandmark:(Landmark *)landmark;

@end
