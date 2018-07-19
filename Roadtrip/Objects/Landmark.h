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

//Location
@property (nonatomic, strong) NSString *address;
+(NSMutableArray *) initWithArray: (NSArray *) landmarksArray;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

//Tyep
@property(assign, nonatomic)Boolean isEvent;
@end
