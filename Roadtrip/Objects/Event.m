//
//  Event.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype) initWithYelpDictionary: (NSDictionary *) dictionary {
    
    self = [super init];
    
    
    if(self) {
        self.name = dictionary[@"name"];
        self.category = dictionary[@"category"];
        self.eventDescription = dictionary[@"description"];
        self.eventSiteUrl = dictionary[@"event_site_url"];
        self.eventId = dictionary[@"id"];
        self.imageUrl = dictionary[@"image_url"];
        NSDictionary *locationDict = dictionary[@"location"];
        self.address = locationDict[@"display_address"][0];
        self.latitude = dictionary[@"latitude"];
        self.longitude = dictionary[@"longitude"];
        self.isEvent = YES;
        
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
        
        //convert to unix time
        self.startTimeUnix = [self.startDate timeIntervalSince1970];
        
        self.endTimeUnix = [self.endDate timeIntervalSince1970];
        
    }
    
    return self;
    
    
}

+ (NSMutableArray *) eventsWithYelpArray:(NSArray *) dictionaries {
    
    NSMutableArray *events = [NSMutableArray array];
    
    for(NSDictionary *dictionary in dictionaries) {
        
        Event *event = [[Event alloc] initWithYelpDictionary:dictionary];
        
        [events addObject:event];
        
    }
    
    return events;
    
}

-(instancetype) initWithEventbriteDictionary: (NSDictionary *) dictionary withLatitude: (NSString *) latitude withLongitude: (NSString *) longitude withAddress: (NSString *) address {
    
    self = [super init];
    
    if(self) {
        
        //Event description
        NSDictionary *nameDictionary = dictionary[@"name"];
        self.name = nameDictionary[@"text"];
        
        self.category = dictionary[@"category_id"];
        
        NSDictionary *descriptionDictionary = dictionary[@"description"];
        self.eventDescription = descriptionDictionary[@"text"];
        
        self.eventSiteUrl = dictionary[@"url"];
        self.eventId = dictionary[@"id"];
        
        
        NSDictionary *logoDictionary = dictionary[@"logo"];
        NSDictionary *origialLogoDictionary = logoDictionary[@"original"];
        self.imageUrl = origialLogoDictionary[@"url"];
        
        //Event location
        
        self.address = address;
        self.latitude = latitude;
        self.longitude = longitude;
        
        self.isEvent = YES;
        
        //Event start and end times
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSDictionary *startDictionary = dictionary[@"start"];
        NSString *localTimeStart = startDictionary[@"local"];
        

        NSString *dayString = [localTimeStart substringToIndex:10];
        NSString *timeString = [localTimeStart substringFromIndex:11];
        
        localTimeStart = [NSString stringWithFormat:@"%@ %@", dayString, timeString];

        self.startDate = [formatter dateFromString: localTimeStart];
        
        
        NSDictionary *endDictionary = dictionary[@"end"];
        NSString *localTimeEnd = endDictionary[@"local"];
        
        
        dayString = [localTimeEnd substringToIndex:10];
        timeString = [localTimeEnd substringFromIndex:11];
        
        localTimeEnd = [NSString stringWithFormat:@"%@ %@", dayString, timeString];
        
        self.endDate = [formatter dateFromString: localTimeEnd];
        
    }
    
    return self;
    
}


+ (NSArray *) sortEventArrayByEndDate: (NSArray *) array {
	
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sd]];
    
    return sortedArray;
    
}

@end
