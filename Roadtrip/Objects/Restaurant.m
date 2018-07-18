//
//  Restaurant.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant


-(instancetype) initWithDictionary: (NSDictionary *) dictionary {
    
    self = [super init];
    
    
    if(self) {
        
        NSLog(@"%@", dictionary);
        
        self.rating = [dictionary[@"rating"] doubleValue];
        
        self.price = dictionary[@"price"];
        
        self.restaurantId = dictionary[@"id"];
        
        self.name = dictionary[@"name"];
        
        self.phone = dictionary[@"phone"];
        
        self.url = dictionary[@"url"];
        
        NSDictionary *locationDictionary = dictionary[@"coordinates"];
        
        self.latitude = locationDictionary[@"latitude"];
        
        self.longitude = locationDictionary[@"longitude"];
        
        self.imageUrl = dictionary[@"image_url"];
        
    }
    
    return self;
    
}

+ (NSMutableArray *) eventsWithArray:(NSArray *) dictionaries {
    
    NSMutableArray *restaurants = [NSMutableArray array];
    
    for(NSDictionary *dictionary in dictionaries) {
        
        Restaurant *restaurant = [[Restaurant alloc] initWithDictionary:dictionary];
        
        [restaurants addObject: restaurant];
        
    }
    
    return restaurants;
    
}


@end
