//
//  SearchBarViewController.h
//  Roadtrip
//
//  Created by Hannah Hsu on 8/3/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MySearchBarDelegate

 -(void) changeCityText: (NSString *) cityString withStateAndCountry: (NSString *) stateAndCountry withLatitude: (NSString *) latitude withLongitude: (NSString *) longitude;
 
 //-(void) changeCityTextWithCity: (NSString *)cityString;
 
@end

@interface SearchBarViewController : UIViewController
@property (weak, nonatomic) id<MySearchBarDelegate> delegate;
@end
