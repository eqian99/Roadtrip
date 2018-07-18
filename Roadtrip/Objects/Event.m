//
//  Event.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype) initWithDictionary: (NSDictionary *) dictionary {
    
    self = [super init];
    
    
    if(self) {
        self.name = dictionary[@"name"];
        self.category = dictionary[@"category"];
        self.eventDescription = dictionary[@"description"];
        self.eventSiteUrl = dictionary[@"event_site_url"];
        self.eventId = dictionary[@"id"];
        self.imageUrl = dictionary[@"image_url"];
        
        self.address = dictionary[@"display_address"];
        self.latitude = dictionary[@"latitude"];
        self.longitude = dictionary[@"longitude"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        self.startDate = [formatter dateFromString: dictionary[@"time_start"]];
        
        NSString *stringEndDate = [NSString stringWithFormat:@"%@", dictionary[@"time_end"]];
        
        if([stringEndDate isEqualToString:@"<null>"]){
            
            int hours = 3;
            
            NSTimeInterval timeInterval = hours * 60 * 60;
            
            self.endDate = [self.startDate dateByAddingTimeInterval:timeInterval];
            
            
        } else {
            
            self.endDate = [formatter dateFromString: dictionary[@"time_end"]];

        }
        
    }
    
    return self;
    
    
}

+ (NSMutableArray *) eventsWithArray:(NSArray *) dictionaries {
    
    NSMutableArray *events = [NSMutableArray array];
    
    for(NSDictionary *dictionary in dictionaries) {
        
        Event *event = [[Event alloc] initWithDictionary:dictionary];
        
        [events addObject:event];
        
    }
    
    return events;
    
}



+ (NSArray *) sortEventArrayByEndDate: (NSArray *) array {
	
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sd]];
    
    return sortedArray;
    
}

@end
