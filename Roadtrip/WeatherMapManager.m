//
//  WeatherMapManager.m
//  Roadtrip
//
//  Created by Hannah Hsu on 8/6/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "WeatherMapManager.h"

@implementation WeatherMapManager

- (void) getWeather:(double) latitude withLongitude:(double) longitude withCompletion: (void(^)(NSDictionary *weatherDictionary, NSError *error))completion {
    NSString *baseUrlString = [NSString stringWithFormat: @"http://api.openweathermap.org/data/2.5/weather?APPID=3e776d3bde663a72caa2859b43c69804&units=imperial"];
    NSString *parametersString = [NSString stringWithFormat:@"&lat=%f&lon=%f", latitude, longitude];
    
    NSString *fullUrlString = [baseUrlString stringByAppendingString:parametersString];
    
    NSURL *url = [NSURL URLWithString:fullUrlString];
    
    NSLog(@"%@", url);
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary, nil);
        }
        
    }];
    [task resume];
}

@end
