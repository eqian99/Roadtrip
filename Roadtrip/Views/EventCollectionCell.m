//
//  EventCollectionCell.m
//  Roadtrip
//
//  Created by Hector Diaz on 8/9/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "EventCollectionCell.h"

@implementation EventCollectionCell


- (IBAction)didPressDirections:(id)sender {
    NSLog(@"Did press event from schedule dashboard");
    
    [self.delegate goToDirections:self];

}



@end
