//
//  Event.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

//Description
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, strong) NSString *eventSiteUrl;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *imageUrl;

//Location
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

//Time
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property(assign, nonatomic)NSTimeInterval startTimeUnix;
@property(assign, nonatomic)NSTimeInterval endTimeUnix;

//Cost

@property (nonatomic) double cost;

//Tyep
@property (assign, nonatomic)Boolean isEvent;

 -(instancetype) initWithDictionary: (NSDictionary *) dictionary;
+ (NSMutableArray *) eventsWithArray:(NSArray *) dictionaries;
+(NSArray *) sortEventArrayByEndDate: (NSArray *) array;

@end
