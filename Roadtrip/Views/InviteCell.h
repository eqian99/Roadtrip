//
//  InviteCell.h
//  Roadtrip
//
//  Created by Hector Diaz on 8/1/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@protocol InviteCellDelegate;

@interface InviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFObject *invite;

@property (nonatomic, weak) id<InviteCellDelegate> delegate;

@end

@protocol InviteCellDelegate
-(void) dismissController;
@end
