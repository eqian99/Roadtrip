//
//  EventDetailsViewController.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/19/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailsViewController : UIViewController
@property (strong, nonatomic)NSArray *activities;
@property (assign, nonatomic)NSInteger index;
@end
