//
//  selectEventsViewController.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/18/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectEventsViewController : UIViewController
@property (nonatomic, strong)NSArray *categories;
@property (assign, nonatomic)double latitude;
@property (assign, nonatomic)double longitude;

@end
