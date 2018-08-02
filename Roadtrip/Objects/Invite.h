//
//  Invite.h
//  Roadtrip
//
//  Created by Hector Diaz on 8/1/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse.h"
@interface Invite : NSObject

@property (strong, nonatomic) NSDate *sentDate;
@property (strong, nonatomic) PFObject *schedule;
@property (strong, nonatomic) PFUser *sender;

@end
