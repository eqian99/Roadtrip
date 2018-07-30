//
//  CategoryViewController.h
//  Roadtrip
//
//  Created by Emma Qian on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController
@property(assign, nonatomic)double latitude;
@property(assign, nonatomic)double longitude;
@property(assign, nonatomic)NSTimeInterval startOfDayUnix;
@property(assign, nonatomic)NSTimeInterval endOfDayUnix;

@end
