//
//  Schedule.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/26/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"

@interface Schedule : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) PFRelation *eventsRelation;

@property (nonatomic, strong) NSDate *createdDate;

@end
