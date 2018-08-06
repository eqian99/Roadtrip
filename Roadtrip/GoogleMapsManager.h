//
//  GoogleMapsManager.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/17/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleMapsManager : NSObject
- (void) getPlacesNearLatitude:(double) latitude nearLongitude:(double) longitude withRadius:(int) radius withCompletion: (void(^)(NSArray *placesDictionaries, NSError *error))completion;

- (void) autocomplete:(NSString *) city withCompletion: (void(^)(NSArray *predictionDictionaries, NSError *error))completion;

- (void) getPlacesDetailsWithId: (NSString *) placeId withCompletion: (void(^)(NSDictionary *placeDictionary, NSError *error))completion;

- (void) getMuseumsNearLatitude:(double) latitude nearLongitude:(double) longitude withRadius:(int) radius withCompletion: (void(^)(NSArray *placesDictionaries, NSError *error))completion;

@end
