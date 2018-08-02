//
//  Event.m
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "Event.h"
#import "EventbriteManager.h"

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
        self.isMeal = NO;
        self.isBreakfast = NO;
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

-(instancetype) initWithEventbriteDictionary: (NSDictionary *) dictionary {
    
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
        
        if([dictionary[@"logo"] isKindOfClass:[NSNull class]]) {
            
            NSLog(@"Doesn't have LOGOooooo");
            
        } else {
            
            
            NSDictionary *logoDictionary = dictionary[@"logo"];
            NSDictionary *origialLogoDictionary = logoDictionary[@"original"];
            self.imageUrl = origialLogoDictionary[@"url"];
            
            
        }
        
        self.venueId = dictionary[@"venue_id"];
        
        [[EventbriteManager new] getVenueWithId:self.venueId completion:^(NSDictionary *venue, NSError *error) {
            
            if(venue) {
                
                NSString *latitude = venue[@"latitude"];
                
                NSString *longitude = venue [@"longitude"];
                
                NSString *address = venue[@"localized_address_display"];
                
                self.latitude = latitude;
                
                self.longitude = longitude;
                
                self.address = address;
                
                
            } else {
                
                NSLog(@"Error getting venue of event");
                
            }
            
        }];
        
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
        
        //convert to unix time
        self.startTimeUnix = [self.startDate timeIntervalSince1970];
        
        self.endTimeUnix = [self.endDate timeIntervalSince1970];
        
        self.startTimeUnixTemp = self.startTimeUnix;
        
        self.endTimeUnixTemp = self.endTimeUnix;
        
        // if >= 12 hours, assume it is a long event
        if (self.endTimeUnix - self.startTimeUnix >= 43200)
        {
            self.isFlexible = YES;
        }
        else
        {
            self.isFlexible = NO;
        }
        
    }
    
    return self;
    
}



+ (NSMutableArray *) eventsWithEventbriteArray:(NSArray *) dictionaries {
    
    NSMutableArray *events = [NSMutableArray array];
    
    for(NSDictionary *dictionary in dictionaries) {
        
        Event *event = [[Event alloc] initWithEventbriteDictionary:dictionary];
        
        [events addObject:event];
        
    }
    
    return events;
}

+ (NSArray *) sortEventArrayByEndDate: (NSArray *) array {
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"endDate" ascending:YES];
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sd]];
    
    return sortedArray;
    
}

+ (NSArray *) sortEventArrayByStartDate: (NSArray *) array {
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"startTimeUnixTemp" ascending:YES];
    
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sd]];
    
    return sortedArray;
}

@end
