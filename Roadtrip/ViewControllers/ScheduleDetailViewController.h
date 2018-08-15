//
//  SavedScheduleViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/27/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Schedule.h"
#import "MSWeekViewDecoratorFactory.h"


@interface ScheduleDetailViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIImageView *scheduleCoverImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *segmentImageView;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *membersCollectionView;



@property (nonatomic) int selectedView;
@property (nonatomic) CGRect scheduleViewRect;
@property (nonatomic) CGRect collectionViewRect;


@property (strong, nonatomic) IBOutlet MSWeekView *scheduleView;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSMutableArray *podEvents;
@property (strong, nonatomic) NSMutableArray *restaurants;
@property (strong, nonatomic) NSArray *members;
@property (strong, nonatomic) Schedule *schedule;
@property (assign, nonatomic)NSInteger indexSelected;
@property (strong, nonatomic) MSWeekView *decoratedScheduleView;

@property (assign, nonatomic) double latitudeSelected;
@property (assign, nonatomic) double longitudeSelected;

@end
