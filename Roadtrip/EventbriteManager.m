//
//  EventbriteManager.m
//  eventbrite api test
//
//  Created by Hector Diaz on 7/12/18.
//  Copyright © 2018 Hector Diaz. All rights reserved.
//

#import "EventbriteManager.h"

@implementation EventbriteManager

- (void)getEventCategories:(void(^)(NSDictionary *categories, NSError *error))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://www.eventbriteapi.com/v3/categories/?token=DML5RT7O2YSNEXPFG3ZC"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
        if (error != nil) {

            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *categoryDictionary = dataDictionary[@"categories"];
                                    
            completion(categoryDictionary, nil);
            
        }
        
    }];
    [task resume];
    
}

- (void)getEventsWithCoordinates: (CLLocationCoordinate2D) coordinate completion:(void(^)(NSDictionary *categories, NSError *error))completion {
    
    NSString *latitudeString = [NSString stringWithFormat: @"%f", coordinate.latitude];
    
    NSString *longitudeString = [NSString stringWithFormat: @"%f", coordinate.longitude];
    
    NSString *urlString = [NSString stringWithFormat: @"https://www.eventbriteapi.com/v3/events/search/?token=DML5RT7O2YSNEXPFG3ZC&location.latitude=%@&location.longitude=%@", latitudeString, longitudeString];
    
    NSLog(urlString);
    
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            
            completion(nil, error);
            
        }
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *eventsDictionary = dataDictionary[@"events"];
                        
            completion(eventsDictionary, nil);
            
        }
        
    }];
    [task resume];

    
}


@end
