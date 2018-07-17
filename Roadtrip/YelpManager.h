//
//  YelpManager.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YelpManager : NSObject

- (void)getEventCategories:(void(^)(NSDictionary *categories, NSError *error))completion;

- (void) getEventsWithCategory: (NSString *) category withLatitude:(double) latitude withLongitude: (double) longitude withUnixStartDate: (NSString *)startDate withUnixEndDate: (NSString *)endDate withCompletion: (void(^)(NSDictionary *eventsDictionary, NSError *error))completion;

- (void) getEventsWithCategories: (NSArray *) categories withLatitude:(double) latitude withLongitude: (double) longitude withUnixStartDate: (NSString *)startDate withUnixEndDate: (NSString *)endDate withCompletion: (void(^)(NSDictionary *eventsDictionary, NSError *error))completion;

-(NSString *) getCategoriesParameterFormat: (NSArray *) categories;


@end
