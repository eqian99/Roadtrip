//
//  GoogleMapsManager.m
//  Roadtrip
//
//  Created by Hannah Hsu on 7/17/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "GoogleMapsManager.h"

@implementation GoogleMapsManager

- (void) getPlacesNearLatitude:(double) latitude nearLongitude: (double) longitude withCompletion: (void(^)(NSArray *placesDictionaries, NSError *error))completion {
    NSString *baseUrlString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?radius=30000&type=park&key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc";
    NSString *parametersString = [NSString stringWithFormat:@"&location=%f,%f", latitude, longitude];
    
    NSString *fullUrlString = [baseUrlString stringByAppendingString:parametersString];
    
    NSURL *url = [NSURL URLWithString:fullUrlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"results"], nil);
        }
        
    }];
    [task resume];
}

- (void) autocomplete:(NSString *) city withCompletion: (void(^)(NSArray *predictionDictionaries, NSError *error))completion {
    NSString *baseUrlString = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyBNbQUYoy3xTn-270GEZKiFz9G_Q2xOOtc&types=(cities)";
    NSString *parametersString = [NSString stringWithFormat:@"&input=%@", [self parseParameters:city]];
    NSString *fullUrlString = [baseUrlString stringByAppendingString:parametersString];
    
    NSURL *url = [NSURL URLWithString:fullUrlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            completion(dataDictionary[@"predictions"], nil);
        }
        
    }];
    [task resume];
}

-(NSString *) parseParameters:(NSString *) city{
    return [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}
@end
