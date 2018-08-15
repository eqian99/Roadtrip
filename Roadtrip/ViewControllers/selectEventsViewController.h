//
//  selectEventsViewController.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface selectEventsViewController : UIViewController
@property (nonatomic, strong)NSArray *categories;
@property (nonatomic, strong) NSString *photoReference;
@property (assign, nonatomic)double latitude;
@property (assign, nonatomic)double longitude;
@property (assign, nonatomic)CLLocation *currentLocation;
@property (assign, nonatomic) NSString *city;
@property (assign, nonatomic) NSString *stateAndCountry;
@property(assign, nonatomic)NSTimeInterval startOfDayUnix;
@property(assign, nonatomic)NSTimeInterval endOfDayUnix;
@property (assign, nonatomic)NSTimeInterval breakfastUnixTime;
@property (assign, nonatomic)NSTimeInterval lunchUnixTime;
@property (assign, nonatomic)NSTimeInterval dinnerUnixTime;
@end

