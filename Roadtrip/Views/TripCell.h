//
//  TripCell.h
//  Roadtrip
//
//  Created by Hector Diaz on 8/3/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
@interface TripCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;

@property (strong, nonatomic) Schedule *schedule;


@end
