//
//  RestaurantChooserViewController.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/31/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RestaurantChooserViewControllerDelegate
- (void)didSave:(int)index withName:(NSString *)name withAddress:(NSString *)address;
@end

@interface RestaurantChooserViewController : UIViewController
@property (strong, nonatomic)NSMutableArray *restaurants;
@property (strong, nonatomic)id<RestaurantChooserViewControllerDelegate>delegate;
@property (assign, nonatomic)int index;
@end
