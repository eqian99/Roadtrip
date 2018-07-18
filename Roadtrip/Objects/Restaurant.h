//
//  Restaurant.h
//  Roadtrip
//
//  Created by Hector Diaz on 7/16/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic) double rating;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *restaurantId;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *url;


@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;

@property (nonatomic, strong) NSString *imageUrl;

-(instancetype) initWithDictionary: (NSDictionary *) dictionary;
+ (NSMutableArray *) eventsWithArray:(NSArray *) dictionaries;

@end
