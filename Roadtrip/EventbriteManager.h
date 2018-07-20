//
//  EventbriteManager.h
//  eventbrite api test
//
//  Created by Hector Diaz on 7/12/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface EventbriteManager : NSObject

- (void)getEventCategories:(void(^)(NSDictionary *categories, NSError *error))completion;

- (void)getEventsWithCoordinates: (CLLocationCoordinate2D) coordinate completion:(void(^)(NSArray *categories, NSError *error))completion;

- (void)getEventsWithCoordinates: (CLLocationCoordinate2D) coordinate withStartDateUTC: (NSString *) startDateUTC completion:(void(^)(NSArray *categories, NSError *error))completion;

- (void)getVenueWithId: (NSString *) stringId completion:(void(^)(NSDictionary *venue, NSError *error))completion;

@end
