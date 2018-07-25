//
//  Landmark.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/17/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Landmark : NSObject
//Description
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSString *photoReference;
//Location
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

+(NSMutableArray *) initWithArray: (NSArray *) landmarksArray;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// for assgining time in schedules 
@property(assign, nonatomic)NSTimeInterval startTimeUnixTemp;
@property(assign, nonatomic)NSTimeInterval endTimeUnixTemp;

//Tyep
@property(assign, nonatomic)Boolean isEvent;
@end
