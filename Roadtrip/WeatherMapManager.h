//
//  WeatherMapManager.h
//  Roadtrip
//
//  Created by Hannah Hsu on 8/6/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherMapManager : NSObject

- (void) getWeather:(double) latitude withLongitude:(double) longitude withCompletion: (void(^)(NSDictionary *weatherDictionary, NSError *error))completion ;

@end
