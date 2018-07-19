//
//  Landmark.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/17/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "Landmark.h"

@implementation Landmark
-(instancetype) initWithDictionary: (NSDictionary *) dictionary {
    
    self = [super init];
    
    
    if(self) {
        self.name = dictionary[@"name"];
        self.address = dictionary[@"vicinity"];
        self.rating = dictionary[@"rating"];
        self.isEvent = NO;
    }
    
    return self;
}

+(NSMutableArray *) initWithArray: (NSArray *) landmarksArray{
    NSMutableArray *landmarks = [NSMutableArray new];
    for(NSDictionary *landmarkDict in landmarksArray){
        Landmark *newLandmark = [[Landmark alloc] initWithDictionary:landmarkDict];
        [landmarks addObject:newLandmark];
    }
    return landmarks;
}

@end

