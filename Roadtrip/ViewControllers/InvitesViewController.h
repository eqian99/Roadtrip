//
//  InvitesViewController.h
//  Roadtrip
//
//  Created by Hector Diaz on 8/1/18.
//  Copyright © 2018 heh17. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *invitesTableView;
@property (strong, nonatomic) NSArray *invites;

@end
