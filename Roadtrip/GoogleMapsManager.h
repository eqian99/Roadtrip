//
//  GoogleMapsManager.h
//  Roadtrip
//
//  Created by Hannah Hsu on 7/17/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleMapsManager : NSObject
- (void) getPlacesNearLatitude:(double) latitude nearLongitude: (double) longitude withCompletion: (void(^)(NSArray *placesDictionary, NSError *error))completion;

- (void) autocomplete:(NSString *) city withCompletion: (void(^)(NSArray *predictionDictionaries, NSError *error))completion;
@end
