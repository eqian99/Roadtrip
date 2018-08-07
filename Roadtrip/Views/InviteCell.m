//
//  InviteCell.m
//  Roadtrip
//
//  Created by Hector Diaz on 8/1/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import "InviteCell.h"
#import "Parse.h"

@implementation InviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTappedAccept:(id)sender {
    PFRelation *schedulesRelation = [[PFUser currentUser] relationForKey:@"schedules"];
    PFObject *schedule = [self.invite objectForKey:@"schedule"];
    [schedulesRelation addObject:schedule];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error adding the schedule to user");
        }else {
            NSLog(@"Successfully the schedule to user");
            [schedule fetchIfNeeded];
            PFRelation *scheduleMembersRelation = [schedule relationForKey:@"members"];
            [scheduleMembersRelation addObject:[PFUser currentUser]];
            [schedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Error attaching user to schedule's member relation");
                }else{
                    NSLog(@"Successfully attached member to schedule relation");
                    [self.invite deleteInBackground];
                    [self.delegate dismissController];
                }
            }];
        }
    }];
    
}


@end
