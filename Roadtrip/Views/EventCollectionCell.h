//
//  EventCollectionCell.h
//  Roadtrip
//
//  Created by Hector Diaz on 8/9/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Landmark.h"

@protocol EventCollectionCellDelegate;

@interface EventCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) Landmark *landmark;

@property (nonatomic, weak) id<EventCollectionCellDelegate> delegate;

@end

@protocol EventCollectionCellDelegate
-(void) goToDirections: (EventCollectionCell *) cell;
@end
