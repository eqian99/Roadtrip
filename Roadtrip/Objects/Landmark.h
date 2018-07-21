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
+(NSMutableArray *) initWithArray: (NSArray *) landmarksArray;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

//Tyep
@property(assign, nonatomic)Boolean isEvent;

// assign temp start and end time for scheduling 
@property(assign, nonatomic)NSTimeInterval startTimeUnixTemp;
@property(assign, nonatomic)NSTimeInterval endTimeUnixTemp;
@end
