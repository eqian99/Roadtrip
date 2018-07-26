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
        
        self.placeId = dictionary[@"place_id"];
        self.name = dictionary[@"name"];
        self.address = dictionary[@"vicinity"];
        self.rating = dictionary[@"rating"];
        
        NSDictionary *geometry = dictionary[@"geometry"];
        NSDictionary *location = geometry[@"location"];
        self.latitude = location[@"lat"];
        self.longitude = location[@"lng"];
        
        
        self.isEvent = NO;
        NSArray *photos = dictionary[@"photos"];
        NSDictionary *myPhoto = photos[0];
        self.photoReference = myPhoto[@"photo_reference"];
        
        
        
    
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

